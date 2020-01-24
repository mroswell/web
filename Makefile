# SOURCE
# https://github.com/letsencrypt/website


GO111MODULE=on
GOBIN=${GOPATH}/bin

LIB_NAME=website
LIB=resources/$(LIB_NAME)
LIB_BRANCH=dev
#LIB_BRANCH=flutter_web
LIB_FSPATH=$(LIB)
LE_REPO=https://github.com/letsencrypt/website.git

help:  ## Display this help
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)


print: ## print

	@echo
	@echo GOPATH: $(GOPATH)
	@echo GOBIN: $(GOBIN)
	@echo

	@echo
	@echo SOURCE Hugo Web site:
	@echo LIB_NAME: $(LIB_NAME)
	@echo LIB: $(LIB)
	@echo LIB_BRANCH: $(LIB_BRANCH)
	@echo LIB_FSPATH: $(LIB_FSPATH)
	@echo

git-print:
	cd $(LIB_FSPATH) && git status

git-clean:
	rm -rf $(LIB_FSPATH)

git-upstream:
	cd $(GOPATH)/resources && git clone $(LE_REPO)

git-update:
	cd $(LIB_FSPATH) && git pull origin master
	
code:
	code $(LIB_FSPATH)

###

os-dep: ## os-dep
	# hugo
	brew install hugo

	# install mage
	go get -u -d github.com/magefile/mage

	# firebase cli
	brew install firebase-cli

	## gcloud
	brew cask install google-cloud-sdk

gsheet: ## gsheet
	# Runs the golang gsheet to pull the pre-transaltioned markdown.
	go get -u github.com/getcouragenow/bootstrap/tool/googlesheet
	googlesheet -option=hugo

modify: ## modify
	# This invokes the monster modification script
	# Call the golang code
	go run import.go
	mage FixText

modify-text: ## fix text 
	mage FixText

hugo-build: ## hugo-build
	cd $(LIB) && hugo
	# ls -al $(LIB_FSPATH)/public

hugo-run: ## hugo-run
	# cd $(LIB_FSPATH) && hugo server -F
	cd $(LIB) && hugo server -F

	#if this doesn't work, try 'hugo server -D'
	# cd $(LIB_FSPATH) && hugo server -D
	
hugo-open: ## hugo-open
	open http://localhost:1313/

### deploy ( not using )
GCLOUD_PROJ_ID=getcourage-web-example-letencrypt
deploy-gc:
	# see: https://stephenmann.io/post/hosting-a-hugo-site-in-a-google-bucket/
	
	# create proj
	gcloud projects create $(GCLOUD_PROJ_ID)
	gcloud config set project $(GCLOUD_PROJ_ID)
	gsutil mb gs://example.getcouragenow.org/
	#cd $(LIB_FSPATH) && hugo deploy -h

# Deploy to Firebase ( using this for ease for now )

# TOGGLE environment:
# PROD
PROD_FB_PROJ_ID=winwisely-getcourage-org
# DEV
DEV_FB_PROJ_ID=winwisely-letsencrypt-web

FB_PROJ_CONSOLEURL=https://console.firebase.google.com/project/$(PROD_FB_PROJ_ID)

deploy-fb-init:
	# 1. ONE TIME: make the project here:https://console.firebase.google.com/
	# web console:  https://console.firebase.google.com/project/getcourage-web-letencrypt/overview

	#firebase init 
	firebase init 

	# firebase login
	firebase login --no-localhost

deploy-fb-ci-init: ## deploy-fb-ci.init
	# get token 
	

	firebase projects:list 


deploy-fb-console:
	# opens the web console.
	open $(FB_PROJ_CONSOLEURL)/settings/general

	open $(FB_PROJ_CONSOLEURL)/hosting/main


deploy-build:
	# rebuilds hugo and copies output directory to root of deployment
	cd $(LIB_FSPATH) && hugo -D
	ls -al $(LIB_FSPATH)/public
	# does the actual push deploy to their server.
	rm -R ./public
	cp -R $(LIB_FSPATH)/public ./public

deploy-local-fb: deploy-build ## deploy-local-fb
	firebase serve
	
deploy-fb: deploy-build ## deploy-fb
	
	## get token
	firebase login:ci

	#firebase deploy
	
	firebase deploy --token $(FIREBASE_TOKEN)


