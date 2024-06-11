#!/bin/bash

function check_and_copy() {
	local tags=($1) # 将标签字符串拆分成数组
	local file="$2"
	local dist_dir="$3"

	local fileName="$(basename "${file}")"

	if fd -L "${fileName}" "${dist_dir}" | grep -q "md"; then
		echo "${dist_dir}/${fileName} has existed, return ..."
		return 1
	fi

	# 构造匹配任一标签的正则表达式
	local pattern=""
	for tag in "${tags[@]}"; do
		if [[ -n "$pattern" ]]; then
			pattern+="|"
		fi
		pattern+="^\s*- $tag\$"
	done

	# 使用 rg 检查文件是否包含任一特定标签
	if rg -q "$pattern" "${file}"; then
		ln "$(realpath "${file}")" "${dist_dir}/"

		echo "${file} has has linked"
	else
		return 1
	fi
}

function copy_tag_files() {
	local tag_string="$1" # 将所有标签作为一个字符串传递
	local dist_dir="${HOME}/CodeSpace/my-blog/src/posts"

	# 确保目标目录存在
	if [[ ! -d "$dist_dir" ]]; then
		echo "${dist_dir} has not existed."
		exit 1
	fi

	find . -maxdepth 1 -type d -name "CS-*" | while read cs_src_dir; do
		echo "Processing directory: $cs_src_dir"
		fd . "$cs_src_dir" --extension md --follow | while read -r file; do
			check_and_copy "${tag_string}" "${file}" "${dist_dir}"
		done
	done

	echo "finished"
}

# Usage example: Passing multiple tags separated by spaces
copy_tag_files "Blog"
