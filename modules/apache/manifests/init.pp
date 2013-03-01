class apache {

	file { "/var/log/apache2/error.log":
	   ensure => "link",
	   target => "/srv/apache2-error.log";
	} ->

	package { "apache2":
		require => Exec["apt-update"],
		ensure  => present;
	}

	service { "apache2":
		ensure => running,
		require => Package["apache2"],
		hasstatus => true,
		hasrestart => true;
	}

	define disable_site( $name ) {
		exec { "/usr/sbin/a2dissite $name":
			require => Package["apache2"],
			notify => Exec["force-reload-apache2"];
		}
	}

	define enable_site( $name ) {
		exec { "/usr/sbin/a2ensite $name":
			require => Package["apache2"],
			notify => Exec["force-reload-apache2"];
		}
	}

	exec { "force-reload-apache2":
		command => "/etc/init.d/apache2 force-reload",
		refreshonly => true,
		before => Service["apache2"];
	}

# files for apache document root

	file { "/var/www":
		ensure => directory;
	}

	file { "/var/www/srv":
		ensure => directory,
		require => File["/var/www"],
	}

	file { "/srv/index.html":
		source => "puppet:///modules/apache/index.html",
		ensure => present;
	}

	file { "/var/www/srv/index.html":
		ensure => "link",
		target => "/srv/index.html",
		require => File["/var/www/srv"];
	}

	file { "/srv/favicon.ico":
		source => "puppet:///modules/apache/favicon.ico",
		ensure => present;
	}

	file { "/var/www/srv/favicon.ico":
		ensure => 'link',
		target => '/srv/favicon.ico',
		require => File["/var/www/srv"];
	}

	file { "/srv/style.css":
		source => "puppet:///modules/apache/style.css",
		ensure => present;
	}

	file { "/var/www/srv/style.css":
		ensure => 'link',
		target => '/srv/style.css',
		require => File["/var/www/srv"];
	}

	file { "/srv/Wikidata-logo-demo.png":
		source => "puppet:///modules/apache/Wikidata-logo-demo.png",
		ensure => present;
	}

	file { "/var/www/srv/Wikidata-logo-demo.png":
		ensure => 'link',
		target => '/srv/Wikidata-logo-demo.png',
		require => File["/var/www/srv"];
	}

}
