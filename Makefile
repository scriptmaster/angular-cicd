# develop, distribute
dev:
	docker run -it --rm -p 5005:5005 --name dev-web-app app-build

dist:
	make deploy
	docker run -it --rm -p 8880:80 --name stage-web-app ng-web


# build stages

install:
	docker build --target ci-cache -t app-ci-cache .

build:
	docker build --target builder -t app-build .

deploy:
	docker build --target web -t ng-web .



ANGULAR_PROJECT_NAME=ng-app

# port options
angular.json-task:
	dotnet json get angular.json cli:analytics
	dotnet json set angular.json cli:analytics false
	dotnet json get angular.json projects:${ANGULAR_PROJECT_NAME}:architect:serve:options:port
	dotnet json set angular.json projects:${ANGULAR_PROJECT_NAME}:architect:serve:options:port 5005

package.json-task:
	dotnet json get package.json scripts:start
	dotnet json set package.json scripts:start "ng serve --host 0.0.0.0 --port 5005 --disable-host-check"

# dotnet json tool ported to Win/OSX/Linux: https://github.com/scriptmaster/dotnet-json/releases
