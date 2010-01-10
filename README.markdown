script/plugin now keeps track of your installation.

# Install
    `script/plugin install git://github.com/grosser/tracked_plugins.git`

# Usage
###Install
As usual:
    script/plugin install git://github.com/grosser/parallel_specs.git

###List
With revision and installed_at date
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


# TODO
 - `script/plugin diff` that shows what changed in the remote <-> review before updating
 - do a real update: checkout, copy .git over, rebase/stash <-> keep modifications
 - add `script/plugin reinstall`
 - create PLUGIN_INFO.yml for tracked_plugins after installation (install.rb)

Author
======
[Michael Grosser](http://pragmatig.wordpress.com)  
grosser.michael@gmail.com  
Hereby placed under public domain, do what you want, just do not hold me accountable...