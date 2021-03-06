
# GIT AUTO MIRROR

## Status
The replication seems to be working well - but there currently isn't any locking taking place. I wonder if there is any way I could do this within the git protocol and keep everything protocol agnostic? A special branch containing a single ''lock'' file?

## Situation
Imagin you have three teams around the world all working on the same project. For performance reasons and local management etc. they all need a local central repo to aid sharing between devs. BUT we want to keep these local repos upto date and more importantly the team that manages those servers don't want to deal with merge conflicts etc. - thats a devs job.

So the hooks within this repos allow you to do this:

```
----------                                      ----------
| Team A | <----------------------------------> | Team B |
----------                                      ----------
    ^                                               ^
    |                                               |
    -----------------------  ------------------------
                          |  |
                         \/  \/
                       ----------
                       | Team C |
                       ----------
```

AND when anyone commits/merges/pushes to master on any of the "local repos" they automattically push the changes to the other "local repos". This could still give raise to merge conflicts though - so before the commit is even accepted locally (at the orginating "local repo") - its locks the other repos to prevent a simultaneous commit breaking everything!

## How to use
Have a look in ''setup\_test.sh'' - it setups up three repos (like the diagram above) and then commits to one of them and checks it made it across. TBH its pretty simple if you're familiar with git.

## Important
__Nobody__ should manually push changes directly into the sync branch - its very important master and sync stay in lock-step.

