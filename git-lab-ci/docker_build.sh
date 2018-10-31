#!/usr/bin/env bash
# [分支名]
branch_name=${CI_COMMIT_REF_NAME//\//\_}
# [maven 编译是否跳过测试]
if [ ! -n "$skipTest" ]; then
	skipTest=false
fi

# [配置选项]
docker_build() {
	# [输出相关信息]
	echo_info $2
	# [推送的环境]
	image_env=$1
	# [将项目名称赋值]
	if [ ! -n "$2" ]; then
		echo ""
	else
		project_name=$2
	fi

	if [ -n "$dockerBuildDir" ]; then
		cd $dockerBuildDir
	fi

	# echo "sudo docker login -u $docker_login -p $docker_pwd $image_server_remote"
	# sudo docker login -u $docker_login -p $docker_pwd $image_server_remote
	# is_interrupt

	echo "sudo docker build -t $image_server_remote/$project_name:$branch_name ."
	#docker build --no-cache=true -t $image_server_remote/$project_name:$branch_name .
	sudo docker build -t $image_server_remote/$project_name:$branch_name .
	is_interrupt

	echo "sudo docker push remote $image_server_remote/$project_name:$branch_name"
	sudo docker push $image_server_remote/$project_name:$branch_name
	is_interrupt
}

# [maven 编译]
mvn_build() {
	if [ -n "$mvnBuildDir" ]; then
		cd $mvnBuildDir
	fi
	echo "mvn package -Dmaven.test.skip=$skipTest -U start"
	mvn package -Dmaven.test.skip=$skipTest -U
	is_interrupt
}

# [脚本不正常退出]
is_interrupt() {
	if [ $? -ne 0 ]; then
		exit 1
	fi
}

# [输出相关信息]
echo_info() {
	echo "" >>${CI_PROJECT_DIR}/dockerfile
	if [ ! -n "$1" ]; then
		echo "ENV git_branch ${CI_COMMIT_REF_NAME}" >>${CI_PROJECT_DIR}/dockerfile
	else
		echo "ENV git_branch ${CI_COMMIT_REF_NAME}" >>${CI_PROJECT_DIR}/$1/dockerfile
	fi
	echo "project_path=${CI_PROJECT_DIR}"
	echo "$branch_name"
}

# [如果tag分支，则编译生产环境与生产镜像]
check_branch_tag() {
	if [[ $branch_name == tag_* ]]; then
		if [ ! -n "$1" ]; then
			mvn_build
			docker_build fmpro
		else
			#多项目结构自已编译
			docker_build fmpro $1
		fi
		exit 0
	fi
}

# [如果develop分支，只做maven build操作]
check_branch_develop() {
	if [[ $branch_name == *develop* ]]; then
		mvn_build
		exit 0
	fi
}

# [如果master分支，只做maven build操作]
check_branch_master() {
	if [[ $branch_name == *master* ]]; then
		mvn_build
		docker_build
		exit 0
	fi
}

# [如果git commit 描述有"@docker"关键字，编译开发环境与开发镜像]
check_git_log_contain_docker() {
	logs=$(git log --no-merges --pretty=format:"%s" -1)
	if [[ $logs == *@docker* ]]; then
		echo "docker build start..."

		# 入参1：代表项目名称
		if [ ! -n "$1" ]; then
			# [maven 编译]
			mvn_build
			docker_build fmdev
		else
			#多项目结构自已编译
			docker_build fmdev $1
		fi

		exit 0
	fi
	echo "项目$project_name 没有@docker关键字，不执行dock build操作"
}

# [如果tag分支，则直接构建]
echo "执行docker build 脚本.start"
echo "branch_name=${CI_COMMIT_REF_NAME//\//\_}"d
# [如果develop分支，只做maven build操作]
check_branch_develop
# [如果master分支，只做maven build操作]
check_branch_master
# [如果tag分支，则编译生产环境与生产镜像]
check_branch_tag $1
# [如果git commit 描述有"@docker"关键字，编译开发环境与开发镜像]
check_git_log_contain_docker $1

echo "执行完毕"
exit 0
