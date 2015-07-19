pages_branch = master
output_dir = _site

build:
	@liquidluck build
	@cp -r ./resume/ $(output_dir)/resume/
	@cp -r ./test/ $(output_dir)/test/
	@cp ./favicon.ico $(output_dir)
publish: build
	@ghp-import -b $(pages_branch) $(output_dir)
	@git push origin $(pages_branch)
