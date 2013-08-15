# Varying Vagrant Vagrants

Varying Vagrant Vagrants is an evolving [Vagrant](http://vagrantup.com) configuration focused on [WordPress](http://wordpress.org) development.

* **Contributing**:
* Contributions are more than welcome.
* PMC-specific contributions may be pushed against [PMC's master branch](https://github.com/Penske-Media-Corp/varying-vagrant-vagrants/).
* General contributions: Please submit pull requests against the [10up master branch](https://github.com/10up/varying-vagrant-vagrants/). Thanks!

## Getting Started

### What is Vagrant?

[Vagrant](http://vagrantup.com) is a "tool for building and distributing development environments". It works with virtualization software such as [VirtualBox](http://virtualbox.org) to provide a virtual machine that is sandboxed away from your local environment.

Our fork has customizations specific to PMC, such as nginx configs and databases for all dev sites, required plugins, etc.

### Installing VVV
1. Install [VirtualBox 4.2.16](https://www.virtualbox.org/wiki/Downloads)
    * VVV (and Vagrant) has been tested with this version. If a newer version appears on the downloads page and you don't feel like being a guinea pig, check out the [older downloads](https://www.virtualbox.org/wiki/Download_Old_Builds_4_2) page and download the 4.2.16 release.
1. Install [Vagrant 1.2.5](http://downloads.vagrantup.com/tags/v1.2.5)
    * `vagrant` will now be available as a command in the terminal, try it out.
1. Clone the Varying Vagrant Vagrants repository into a local directory
    * `git clone git://github.com/Penske-Media-Corp/varying-vagrant-vagrants.git vvv`

### Before you run VVV for the first time
1. Install the Vagrant HostsUpdater plugin
	* From VVV's directory on your host machine: {{$ vagrant plugin install vagrant-hostsupdater}}
	** This lets VVV set up your hosts file automatically when it starts
1. Generate a new SSH key for Bitbucket using the script included in the PMC VVV fork: {{$ /path/to/vvv/bitbucket-gen-key.sh}}
	* Have your Bitbucket username (generally the e-mail address you signed up with) and password handy, the script will need it to add the newly-generated key to your Bitbucket account.
	* Don't bother with a passphrase for the SSH key. Although it's more secure, it's also more hassle.  The VVV automation assumes this Bitbucket key is generated without a passphrase.
	* If you mess up, you'll need to remove the following files:
	** {{~/.ssh/bitbucket.org_id_rsa}}
	** {{~/.ssh/bitbucket.org_id_rsa.pub}}
	** Find the entry in {{~/.ssh/config}} preceded by the comment {{# bitbucket.org CONFIG}} and remove it


### The first time you run VVV
1. Change into the new directory
1. Start the Vagrant environment
    * `vagrant up` in the directory where you cloned VVV - *omg magic happens*
    * Be patient, this could take a while, especially on the first run.
1. Visit `http://192.168.50.4` for the VVV dashboard.
1. Make sure everything works
	* [Test wp-cli|http://wp-cli.org/#usage] and make sure it works
	* Test debugging (via xdebug) and make sure it works
	** To turn on xdebug: ssh into your vagrant VM via $ {{vagrant ssh}} then turn on xdebug via $ {{xdebug_on}}
	* Test profiling (via xdebug) and make sure it works
	** You can trigger the generation of profiler files by using the XDEBUG_PROFILE GET/POST parameter.  You'll know it works because you'll see the cachegrind.out files in your /tmp directory

### What Did That Do?

The first time you run `vagrant up`, a pre-packaged virtual machine box is downloaded to your local machine and cached for future use. The file used by Varying Vagrant Vagrants contains an Ubuntu 12.04 installation (Precise release) and is about 280MB.

After this box is download, it begins to boot as a sandboxed virtual machine using VirtualBox. When ready, it runs the provisioning script also provided with this repository. This initiates the download and installation of around 88MB of packages on the new virtual machine.

The time for all of this to happen depends a lot on the speed of your Internet connection. If you are on a fast cable connection, it will more than likely only take several minutes.

On future runs of `vagrant up`, the pre-packaged box will already be cached on your machine and Vagrant will only need to deal with provisioning. If the machine has been destroyed with `vagrant destroy`, it will need to download the full 88MB of packages to install. If the vagrant has been powered off with `vagrant halt`, the provisioning script will run but will not need to download anything.

### Now What?

Now that you're up and running with a default configuration, start poking around and modifying things.

1. Access the server with `vagrant ssh` from your `vvv` directory. You can do pretty much anything you would do with a standard Ubuntu installation on a full server.
    * If you are on a Windows PC, you may need to install additional software for this to work seamlessly. A terminal program such as [Putty](www.chiark.greenend.org.uk/~sgtatham/putty/download.html) will provide access immediately.
1. Power off the box with `vagrant halt` or suspend it with `vagrant suspend`. If you suspend it, you can bring it back quickly with `vagrant resume`, if you halt it, you can bring it back with `vagrant up`.
1. Start modifying and adding local files to fit your needs.
    * The network configuration picks an IP of 192.168.50.4. This works if you are *not* on the 192.168.50.x sub domain, it could cause conflicts on your existing network if you *are* on a 192.168.50.x sub domain already. You can configure any IP address in the `Vagrantfile` and it will be used on the next `vagrant up`
    * If you require any custom SQL commands to run when the virtual machine boots, move `database/init-custom.sql.sample` to `database/init-custom.sql` and edit it to add whichever `CREATE DATABASE` and `GRANT ALL PRIVILEGES` statements you want to run on startup to prepare mysql for SQL imports (see next bullet).
    * Have any SQL files that should be imported in the `database/backups/` directory and named as `db_name.sql`. The `import-sql.sh` script will run automatically when the VM is built and import these databases into the new mysql install as long as the proper databases have already been created via the previous step's SQL.
    * Check out the example nginx configurations in `config/nginx-config/sites` and create any other site specific configs you think should be available on server start. The web directory is `/srv/www/` and default configs are provided for basic WordPress 3.5.1 and trunk setups.
    * Once a database is imported on the initial `vagrant up`, it will persist on the local machine a mapped mysql data directory.
    * Other stuff. Familiarize and all that.

### Credentials and Such

#### WordPress Default - Stable Release
* URL: `http://local.wordpress.dev`
* DB Name: `wordpress_default`
* DB User: `wp`
* DB Pass: `wp`
* Admin User: `admin`
* Admin Pass: `password`

#### WordPress Trunk
* URL: `http://local.wordpress-trunk.dev`
* DB Name: `wordpress_trunk`
* DB User: `wp`
* DB Pass: `wp`
* Admin User: `admin`
* Admin Pass: `password`

#### MySQL Root
* [Connecting to MySQL](https://github.com/10up/varying-vagrant-vagrants/wiki/Connecting-to-MySQL) from local
* User: `root`
* Pass: `blank`

#### WordPress Unit Tests
* DB Name: `wordpress_unit_tests`
* DB User: `wp`
* DB Pass: `wp`

#### APC Dashboard
* Username: `apc`
* Password: `apc`

### What do you get?

A bunch of stuff!

1. [Ubuntu](http://ubuntu.com) 12.04 LTS (Precise Pangolin)
1. [nginx](http://nginx.org) 1.4.2
1. [mysql](http://mysql.com) 5.5.31
1. [php-fpm](http://php-fpm.org) 5.4.17
1. [memcached](http://memcached.org/) 1.4.13
1. PHP [memcache extension](http://pecl.php.net/package/memcache/3.0.6) 3.0.6
1. [xdebug](http://xdebug.org/) 2.2.1
1. [PHPUnit](http://pear.phpunit.de/) 3.7.21
1. [ack-grep](http://beyondgrep.com/) 2.04
1. [git](http://git-scm.com) 1.8.3.4
1. [subversion](http://subversion.apache.org/) 1.7.9
1. [ngrep](http://ngrep.sourceforge.net/usage.html)
1. [dos2unix](http://dos2unix.sourceforge.net/)
1. [WordPress 3.5.2](http://wordpress.org)
1. [WordPress trunk](http://core.svn.wordpress.org/trunk)
1. [WP-CLI](http://wp-cli.org)
1. [WordPress Unit Tests](http://make.wordpress.org/core/handbook/automated-testing/)
1. [Composer](https://github.com/composer/composer)
1. [phpMemcachedAdmin](https://code.google.com/p/phpmemcacheadmin/) 1.2.2 BETA
1. [phpMyAdmin](http://www.phpmyadmin.net) 4.0.3
1. [Webgrind](https://github.com/jokkedk/webgrind) 1.1

### Feedback?

Let us have it! If you have tips that we need to know, open a new issue or find us in [other ways](http://10up.com). Some blog posts have been written documenting the process that may provide insight....

* [Hi WordPress, Meet Vagrant](http://jeremyfelt.com/code/2013/04/08/hi-wordpress-meet-vagrant/)
* [Evolving WordPress Development With Vagrant](http://jeremyfelt.com/code/2013/03/17/evolving-wordpress-development-with-vagrant/)
* [Varying Vagrant Vagrants](http://jeremyfelt.com/code/2012/12/11/varying-vagrant-vagrants/)
* [A WordPress Meetup Introduction to Vagrant](http://jeremyfelt.com/code/2013/02/04/an-wordpress-meetup-introduction-to-vagrant-what-youll-need/)
* [Clear nginx Cache in Vagrant](http://jeremyfelt.com/code/2013/01/08/clear-nginx-cache-in-vagrant/)
