# How to create a dataset for large-scale cluster calculations like this

Create dataset:
```shell
datalad create -c yoda square-lattice-dmft-computations
```

Add code and input, notice in particular that in `input/.gitattributes`:
```shell
* annex.largefiles=nothing
```
Create a ria-sibling (on laptop, to easily publish to cluster):
```shell
datalad create-sibling-ria -s cluster --alias square-lattice-dmft-computations "ria+ssh://login3.physnet.uni-hamburg.de/afs/physnet.uni-hamburg.de/users/th1_we/tsievers/ria-store"
```
This only works if the server `login3` is configured in `.ssh/config`:
```shell
Host login?.physnet.uni-hamburg.de
	User tsievers
```

Can then clone on cluster:
```shell
datalad clone ria+file:///afs/physnet.uni-hamburg.de/users/th1_we/tsievers/ria-store#~square-lattice-dmft-computations
```

And start jobs:
```shell
cd square-lattice-dmft-computations
bash code/submit-all-jobs
```

### Merging results

The results from the jobs get pushed to the original project folder, so do everything on the cluster.
This shows all branches beginning with `job-`:
```shell
git branch -l | grep 'job-' | tr -d ' '
```

So we can merge with:
```shell
git merge -m "Merge results from job cluster" $(git branch -l | grep 'job-' | tr -d ' ')
```
and push back to the ria-store:
```shell
datalad push --to origin
```
Can then update the repo somewhere else and `datalad get` files (which pulls from the ria store)

Delete branches:
```shell
git branch -d $(git branch | grep job-*)
```

### Publish to gitlab and gin

To add gitlab as remote:
```shell
git remote add gitlab git@git.physnet.uni-hamburg.de:tsievers/square-lattice-dmft-results.git
datalad push --to gitlab
```

Create new repo on gin

Create a sibling (be aware of the different URLs!):
```shell
datalad siblings add \
 -d . \
 --name gin \
 --pushurl git@gin.g-node.org:/tjarksievers/square-lattice-dmft-results.git \
 --url https://gin.g-node.org/tjarksievers/square-lattice-dmft-results
```

```shell
git config --unset-all remote.gin.annex-ignore
```

```shell
datalad push --to gin
```

```shell
datalad siblings configure \
   --name gin \
   --as-common-datasrc gin-src
```

and push to it:
```shell
datalad push --to gin
```

Also push to gitlab:
```shell
datalad push --to gitlab
```

To get dataset:
```shell
datalad clone https://git.physnet.uni-hamburg.de/tsievers/square-lattice-dmft-results
```
