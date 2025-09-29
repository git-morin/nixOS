# HPE iLO

I jailbroke my HPE iLO interface on one of my servers (DL360p Gen8), because I added a custom component and
this trips an internal policy of HPE servers which sets the minimal run speed of the **8** onboard fans to 40%.

The custom component is a different RAID controller from the one that was integrated, which allows 'passthrough' HBA to the OS/Hypervisor that I run.
I've disconnected the integrated RAID controller and passed the cable that is connected to the 8-drive backpane to this new RAID controller and then configured it to 'passthrough' all disks.

This new non-HP component basically turned the server into a constant whirring low noise machine. Being that HP left no user facing option to disable this,
people alike to my thinking made a way to [exploit/flash the iLO controller to expose itself via SSH](https://github.com/That-Guy-Jack/HP-ILO-Fan-Control). Additionally, they also add a nice binary called `fan` which lets you edit the fan policies.

So at boot of this machine, I need to have either itself (post OS boot) or some other machine that pings the iLO controller after expected boots, and automate the sending of the `fan` commands.

This essentially makes the server run at 40% speeds only for a couple seconds during boot (after they ran at 80% for their boot test).

I've not yet compiled the script/code I used to automate this, but if I do I'll update this note. 
To note, I used this back when it was in its infancy, and now there exists tooling to make what I did, so I'll probably switch to them instead.