# GetCourageNow Web

## KanBan

https://github.com/orgs/getcouragenow/projects/3

## Getting started

Download [https://github.com/getcouragenow/web/](https://github.com/getcouragenow/web/) or clone using `$ git clone https://github.com/getcouragenow/web.git`

-   Run `$ git fetch`
-   Run `$ git checkout dev` to be on the correct branch

## Local Development

_Makefile_ has all the commands necessary for building, starting server, and deploying to Firebase and must be executed from the checked out root directory of [GetCourageNow](https://github.com/getcouragenow/web.git)

## To install all dependencies:
-   Use bootstrap/os to quick install [Golang 1.13](https://github.com/getcouragenow/bootstrap)
-   Run `$ make os-dep`

-   #### Runtime dependencies (if `$ make dep` fails)
    -   [Golang](https://golang.org/)
    -   [mage](https://github.com/magefile/mage)
    -   [Firebase](https://firebase.google.com/)
    -   [Hugo](https://gohugo.io/getting-started/installing/)


## To clean or update Let's Encrypt codebase:

-   Run `$ make git-clean` to clean Let's Encrypt codebase directory when necessary
-   Run `$ make git-upstream` to pull Let's Encrypt repo if codebase directory is cleaned
-   Or run `$ make git-update` to update Let's Encrypt's codebase directory

## To import content from googlesheet:

-   Run `$ make gsheet`This will create a document called outputs and contains all .
-   To add a new sheet see `/config` folder for more infos.

## To import GetCourageNow content into the Let's Encrypt codebase:

-   Run `$ make modify` to invoke Import.go script. By default it will replace, overwrite, or append to Let's Encrypt codebase.

-   Run `$ make hugo-build` to build after importing GetCourageNow content into Let's Encrypt codebase

-   Run `$ make hugo-run` to start the server.

-   Run `$ make hugo-open` to launch browser to see the build locally.

## To fixe text on one file:

The file `fixe_text.json` is used to replace strings on some files, so how it's work?

- `file_path`: adding file path where there is an error an you want to fixe it.
- `errors`: it's an array contains objects where you need to set "old" and "new" string that you want to replace in the `file_path`.
-  example:
```
{
    "file_path": "resources/website/layouts/partials/head.html",
    "errors": [
        { "old": "@letsencrypt", "new": "@winwisely" }
    ]
}
```
- Run `make modify-text` to fixe and update all strings.

## To fixe text on multiple files:

The file `clean_translation_tags.json` is used by gsheet import to clean tags used to translate, or fixe translation errors for all the files.
```
{
    "error": "NOTRANSLATE_",
    "fixe": ""
}
```
- Run `make gsheet` to fixe and update `outputs` folder.

## Deployment

-   Run `$ make build` to rebuild Hugo
-   If first time deploying:
    -   Run `$ make deploy-fb-init`
-   Run `$ make deploy-fb` to deploy build to Dev server located at [https://getcourage-letsencrypt-web.firebaseapp.com/](https://getcourage-letsencrypt-web.firebaseapp.com/)
