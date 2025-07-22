This is a demo for `p4 push` feature of Perforce Helix Core Server.

# Run Perforce Server Locally (Containerized)

1. build image `podman image build -t perforce:test -f .\Dockerfile`
2. run server `podman run --rm --detach -p 1666:1666 localhost/perforce:test`
3. run `./init.ps1`
   - creates `//sandbox` depot
   - creates `//sandbox/main` stream
   - creates `//test` workspace (Host: current host, Root: PWD)

# Setup for `DVCS p4 push test`

Let's say you have two Perforce servers `A` and `B`. Also say you have streams `//sandbox/a` in `A` and `//sandbox/b` in `B`.
You'd use [p4 push](https://help.perforce.com/helix-core/server-apps/cmdref/current/Content/CmdRef/p4_push.html) to replicate changes in `//sandbox/a` to `//sandbox/b`.

>WARNING: unicode mode server can only send to and receive from unicode mode server.
>
>`p4 -ztag info | Select-String -Pattern unicode` to check if one of the server is unicode enabled

1. Run `p4 configure set server.allowpush=2` on the receiving server
   - this requires admin permission
2. Run `p4 configure set server.allowpush=1` on the sending server
   - this requires admin permission
3. Create `.env` file and fill it in like this:
   ```
   OTHER_P4_SERVER_ADDRESS=domain.of.receiving.server:1666
   DEPOT_MAP=//sending/stream/...      //receiving/stream/...
   ```
4. Run `./remote.ps1` to create a remote spec

5. Run `p4 push -r test-remote` and see if changes are replicated
   - you may need to type password for the user in receiving server
```
PS D:\dev\p4local> p4 push -r test-remote
1 change(s) containing a total of 1 file revision(s) were successfully pushed.
```
