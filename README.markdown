With tracked_plugins installation stays the same and new meta information  
(url / installed_at / revision / plugin-locally-hacked? / ...) is stored <-> used to update/list plugins.

 - simple updating
 - where did the plugin come from ?
 - when was it installed ?
 - what updates are waiting ?
 - did we hack it ?
 - ...

# Install
    script/plugin install git://github.com/grosser/tracked_plugins.git
Install again so that plugin meta data is available for tracked_plugins too.
    script/plugin install --force git://github.com/grosser/tracked_plugins.git

# Usage
###Install
As usual:
    script/plugin install git://github.com/grosser/parallel_specs.git

###List
With revision and installed_at date (for every newly installed plugin)
    script/plugin list
    parallel_specs git://github.com/grosser/parallel_specs.git b195927a98aa351fcefef20730a2fdad7ff3efd5 2010-01-10 15:46:44

###Update
Already most recent revision ?
    script/plugin update parallel_specs
    Plugin is up to date: parallel_specs (b195927a98aa351fcefef20730a2fdad7ff3efd5)

Do we need a update?
    script/plugin update parallel_specs
    Reinstalling plugin: parallel_specs (b195927a98aa351fcefef20730a2fdad7ff3efd5)
    Unpacking objects: 100% (21/21), done.
    From git://github.com/grosser/parallel_specs
     * branch            HEAD       -> FETCH_HEAD

###Info
 - Locally modified == you made some hacks!!
 - checksum == md5 checksum of this plugins folder
 - updateable ?
 - `--log` == show available updates

Already up to date and unmodified
    script/plugin info parallel_specs
    checksum: 8a6d69d6c7fb0928ccae8b451a2914eb
    locally_modified: No
    installed_at: Sun Jan 10 15:59:27 +0100 2010
    revision: b195927a98aa351fcefef20730a2fdad7ff3efd5
    updateable: No
    uri: git://github.com/grosser/parallel_specs.git

With available updates and `--log`
    ./script/plugin info --log parallel_specs
    checksum: 3b243eaad567166d1538a5ffad31fec8
    installed_at: Wed Jan 13 21:10:04 +0100 2010
    locally_modified: No
    revision: a0741c68326d42b726a2ec3c3780d8559fa8404b
    updateable: Yes
    uri: git://github.com/grosser/parallel_specs.git

    available updates:
    b195927a98aa351fcefef20730a2fdad7ff3efd5 4 weeks ago improve docs
    ea7eab3544c641dc6a965a1af45d36cdce3f0bd5 4 weeks ago Add support for parallel_spec.opts
    115e7a802905c06058444764b059763edc06d277 3 months ago micro doc change



# TODO
 - do a real update: checkout, copy .git over, rebase/stash <-> keep modifications

Author
======
[Michael Grosser](http://pragmatig.wordpress.com)  
grosser.michael@gmail.com  
Hereby placed under public domain, do what you want, just do not hold me accountable...