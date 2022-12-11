<h1 align="center">KDevEnv</h1>

# How to use
1. Run the `./build.sh` script.
2. This will create a docker container.
3. This container will be setup with a user shadowing your current user on the host machine (i.e. the username, uid, and gid will all be the same).
4. Create an empty directory in your `$HOME` called `devhome` (this will be bind-mounted as the home directory for the container user).
5. Run the `./localdev` script to launch the container.

