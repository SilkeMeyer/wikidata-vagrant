Wikidata-vagrant
===========

This project is a fork of https://github.com/atdt/wmf-vagrant.git to be adapted to Wikidata.

## Prerequisites ##

You'll need to install [Vagrant][0] and [VirtualBox][1] (>= 4.1).

## Installation ##

```bash
git clone https://github.com/SilkeMeyer/wikidata-vagrant.git
cd ./wikidata-vagrant
git submodule update --init
vagrant up
# If the mediawiki update script (Wikidata::Repo/Exec[repo_update]) fails, reboot the Vagrant machine by running
vagrant reload
```

When you do this for the first time, it will take at least half an hour, because it'll need to fetch the base precise32 (Ubuntu) box and MediaWiki core (twice) plus the extensions and then it will import test data. Once it's done, browse to http://127.0.0.1:8080. You find a Wikidata repo and client preinstalled, served by the guest VM, which is running Ubuntu Precise 32-bit. If you get puppet error messages during the first `vagrant up` command, run `vagrant reload` which also forces puppet to run again. Currently, the pre-installed extensions are Diff, DataValues, UniversalLanguageSelector, Wikibase, DismissableSiteNotice, ApiSandbox and ParserFunctions.

To get a shell on the VM, run `vagrant ssh` inside the wikidata-vagrant directory. To execute maintenance scripts, you have to specify the install paths like so:
To run the populateSitesTable.php script on the repo execute `MW_INSTALL_PATH=/srv/repo /usr/bin/php /srv/extensions/Wikibase/lib/maintenance/populateSitesTable.ph`. For the pollForChanges script on the client you would run `MW_INSTALL_PATH=/srv/client /usr/bin/php /srv/extensions/Wikibase/lib/maintenance/pollForChanges.php`. (These commands can be run from any directory.)

To update to the most recent code from gerrit, run `git pull` outside the VM, in the folders wikidata-vagrant/repo, wikidata-vagrant/client and in all folders in wikidata-vagrant/extensions. To update the extensions Wikibase, Diff and DataValues to the state of our demo system (http://wikidata-test-repo.wikimedia.de and http://wikidata-test-client.wikimedia.de), look at our tags (https://gerrit.wikimedia.org/r/gitweb?p=mediawiki/extensions/Wikibase.git;a=tags) and run `git checkout <tag>`.

To set up a fresh Vagrant machine in the same directory as before, delete the following four files manually and run `vagrant destroy`:
```
rm orig-repo/LocalSettings.php
rm orig-client/LocalSettings.php
rm repo/LocalSettings.php
rm client/LocalSettings.php
```

The repo contains the chemical elements as test data. As an example, look at http://127.0.0.1:8080/client/wiki/Helium. Importing sample pages from WP into the client does not work correctly for the moment because a file permissions issue on a vboxfs file system. Please create pages in the client yourselves - the page names should be the same as in the repo (e.g. "Helium") so that repo and client can communicate.

The vagrant root folder is mounted `/srv`, and port 8080 on the host is forwarded to port 80 on the guest.

The MySQL root credentials are:

* Username: root
* Password: vagrant

The MediaWiki credentials are:

* Username: admin
* Password: vagrant

Profiling information can be found on http://localhost:8080/repo/profileinfo.php, resp. http://localhost:8080/client/profileinfo.php.

## Known issues ##
* Sometimes, the database creation via the MediaWiki install script fails. Try it again.
* Sometimes, the VM is not ready when the change propagation script is already running (via www-data's crontab). Kill the processes (called pollForChanges.php) and start them manually.

  [0]: http://vagrantup.com/v1/docs/getting-started/index.html
  [1]: https://www.virtualbox.org/wiki/Downloads
