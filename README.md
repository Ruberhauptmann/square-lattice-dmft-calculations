In datalad command: --explicit to only save the results, not the changes to .gitattributes etc.

# Project

Create superdataset:
```shell
datalad create -c yoda square-lattice-dmft-computation
```

Create subdataset for results:
```shell
datalad create -d . dmft_results
```

Add code and input, notice in particuar that in input/.gitattributes:
```shell
* annex.largefiles=nothing
```

Configure to clone 
```shell
git config -f .datalad/config datalad.get.subdataset-source-candidate-000ria-store ria+file:///afs/physnet.uni-hamburg.de/users/th1_we/tsievers/ria-store#{id}
```

ria-sibling (on local laptop, to easily publish to cluster):
```shell
datalad create-sibling-ria -s cluster --alias square-lattice-dmft-computations "ria+ssh://login3.physnet.uni-hamburg.de/afs/physnet.uni-hamburg.de/users/th1_we/tsievers/ria-store"
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

Then merging results.
This can be done on the cluster (do this on the cluster)
Update with (inside of dmft_results):
```shell
datalad update -s origin
```

This shows all branches beginning with job- (the branches are not local, so we are using -a, not -l!:
```shell
git branch -a | grep 'job-' | tr -d ' '
```
So we can merge with:
```shell
git merge -m "Merge results from job cluster" $(git branch -a | grep 'job-' | tr -d ' ')
```

e.g. on cluster:
```shell
datalad push --to origin
```

Rediscover files:
```shell
git annex fsck --fast -f cluster-storage
```

The command
```shell
git annex find --not --in cluster-storage
```
should output nothing

Then
```shell
git annex dead here
datalad push --data nothing
```

Can then update the repo somewhere else and datalad get files (which pulls from the ria store)

To add gitlab as remote:
```shell
git remote add gitlab git@git.physnet.uni-hamburg.de:tsievers/square-lattice-dmft-results.git
datalad push --to gitlab 
```

To get dataset:
```shell
datalad clone https://git.physnet.uni-hamburg.de/tsievers/square-lattice-dmft-results
```
cluster-storage is enabled as remote, so can get data.

Question: How can I add gin as a common-data-src, but still want to pull directly from the server?

After cloning the dataset (e.g. in input), edit in input/.git.config:
```shell
[remote "cluster-storage"]
  annex-cost = 000.0
```
(from 200.0)


Need self and ctqmc compiled, also a version of init with the number of processors, so e.g. init_48

Need to set up a conda environment with datalad and jinja2 (for templating the input file) installed

## Publishing the results

Best: Have it on Github and the annexed files somewhere else (e.g. gin in this case), see https://handbook.datalad.org/en/latest/basics/101-139-gin.html#using-gin-as-a-data-source-behind-the-scenes

But consider: I still want to use the RIA store as a source on the cluster to work further, so:

```shell
cd dmft_results
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

# TODO

- define conda environemt with datalad and jinja2
- Docs
  - Better overview for all the parts in code/
  - Better readme:
    - How to go from empty to full dataset
    - How does a run go?
    - How to acquire the results?
- Make another dataset to analyse data T_C(mu) and link it here
- put everything into a bootstrapping script/cookiecutter
