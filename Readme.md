With tracked_plugins plguin installation stays the same and new meta information
(url / branch / revision / installed_at / plugin-locally-hacked? / ...) is stored <-> used to update/list plugins.

 - simple updating through stored url/branch
 - list available plugin updates
 - locally modified(aka hacked) indicator
 - ...

Use `script/plugin` instead of `rails plugin` on Rails 2

# Install
    rails plugin install git://github.com/grosser/tracked_plugins.git
Reinstall so plugin meta data is available for tracked_plugins too.
    rails plugin install --force git://github.com/grosser/tracked_plugins.git

# Usage
Meta info is only available for newly installed plugins.


### Install
As usual:
    rails plugin install git://github.com/grosser/parallel_tests.git

### List
With revision and installed_at date
    rails plugin list
    parallel_tests git://github.com/grosser/parallel_tests.git b195927a98aa351fcefef20730a2fdad7ff3efd5 2010-01-10 15:46:44

### Update
Already most recent revision
    rails plugin update parallel_tests

    Plugin is up to date: parallel_tests (b195927a98aa351fcefef20730a2fdad7ff3efd5)

Update needed
    rails plugin update parallel_tests

    Reinstalling plugin: parallel_tests (b195927a98aa351fcefef20730a2fdad7ff3efd5)
    Unpacking objects: 100% (21/21), done.
    From git://github.com/grosser/parallel_tests
     * branch            HEAD       -> FETCH_HEAD

### Info
 - Locally modified == you made some hacks!!
 - checksum == md5 checksum of this plugins folder
 - updateable ?
 - `--log` == show available updates

Already up to date and unmodified
    rails plugin info parallel_tests

    checksum: 8a6d69d6c7fb0928ccae8b451a2914eb
    locally_modified: No
    installed_at: Sun Jan 10 15:59:27 +0100 2010
    revision: b195927a98aa351fcefef20730a2fdad7ff3efd5
    updateable: No
    uri: git://github.com/grosser/parallel_tests.git

With available updates and `--log`
    rails plugin info --log parallel_tests

    checksum: 3b243eaad567166d1538a5ffad31fec8
    installed_at: Wed Jan 13 21:10:04 +0100 2010
    locally_modified: No
    revision: a0741c68326d42b726a2ec3c3780d8559fa8404b
    updateable: Yes
    uri: git://github.com/grosser/parallel_tests.git

    available updates:
    b195927a98aa351fcefef20730a2fdad7ff3efd5 4 weeks ago improve docs
    ea7eab3544c641dc6a965a1af45d36cdce3f0bd5 4 weeks ago Add support for parallel_spec.opts
    115e7a802905c06058444764b059763edc06d277 3 months ago micro doc change

# TODO
 - `rails plugin update all`
 - `rails plugin info all`
 - get rails core to swap old script/plugin with this

Author
======
[Michael Grosser](http://grosser.it)<br/>
michael@grosser.it<br/>
Hereby placed under public domain, do what you want, just do not hold me accountable...
