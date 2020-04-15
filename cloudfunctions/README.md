# fsfunctions
Bandera Blanca - Cloud Functions


## Requirements
- Google Cloud SDK
- GO
- Firebase admin SDK to GO


## First steps

### Install Google Cloud SDK
To get gcloud to see [here](https://cloud.google.com/sdk/install)

### Install GO sdk
1. Donwload sdk according to your operating system [here](https://golang.org/dl/)

2. Add GO to path
- If you have Linux, you can edit at vim ```~/.profile``` and add the next line
```sh
export PATH=$PATH:/usr/local/go/bin
```
and also
```sh
export GOPATH=$HOME/{Folder Route, where your GO projects will be}
```
- Run, to use GO Modules
```sh
$ echo "export GO111MODULE=on" >> ~/.bash_profile
```

### Install Firebase admin SDK to GO
```sh
$ go get -u firebase.google.com/go
```

### Download Project and go to folder cloudfunctions
```sh
$ git clone git@github.com:EdHuamani/banderablanca.git
```
```sh
$ cd cloudfunctions
```

### Get & update dependencies
```sh
$ go get
$ go mod tidy
```

## Deploy functions

1. To select project run:

```sh
$ gcloud config set project {projectID}
```

2. At the root of the project run:
```sh
$ go get
```

3. After run:
```sh
$ bash run.sh {projectID} 
```

4. Deploy finished!
