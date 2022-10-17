
#Create new repo

/*
resource "github_repository" "task12" {
  name = var.repo_name
  auto_init = true
  visibility = "public"
}

resource "github_repository_file" "file" {
  count = length(var.list_of_files)

  #repository = github_repository.task12.name
  repository = github_repository.task12.name
  #branch = github_repository.task12.branches.0.name
  file = "task-12/${element(var.list_of_files, count.index)}"
  #content = file("${var.path}/${element(var.list_of_files, count.index)}")
  content = file("${path.cwd}/${element(var.list_of_files, count.index)}")
  commit_message = "Files for TASK-12"
  commit_author = "AlexeyRusak"
  commit_email = "alexey_rusak@mail.ru"
  overwrite_on_create = true
}

*/


# Uploat files to existen repo

resource "github_repository_file" "file" {
  count = length(var.list_of_files)

  repository = var.repo_name
  branch = "master"
  file = "task-12/${element(var.list_of_files, count.index)}"
  content = file("${path.cwd}/${element(var.list_of_files, count.index)}")
  commit_message = "Files for TASK-12"
  commit_author = "AlexeyRusak"
  commit_email = "alexey_rusak@mail.ru"
  overwrite_on_create = true
}