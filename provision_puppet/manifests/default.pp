exec { "verify jenkins repo":
    command => '/bin/cp /home/vagrant/jenkins.list /etc/apt/sources.list.d/jenkins.list'
}

exec { "verify jenkins repo key":
    command => "/usr/bin/apt-key adv --fetch-key http://pkg.jenkins.io/debian/jenkins-ci.org.key"
}

exec { "apt-get update":
    command => "/usr/bin/apt-get update",
    onlyif  => "/bin/sh -c '[ ! -f /var/cache/apt/pkgcache.bin ] || /usr/bin/find /etc/apt/* -cnewer /var/cache/apt/pkgcache.bin | /bin/grep . > /dev/null'",
}

exec { "jenkins defaults":
    command => '/bin/cp /home/vagrant/jenkins /etc/default/jenkins',
    before => Package["jenkins"]
}

package { "java":
    name => "openjdk-8-jre-headless",
    ensure => present
}

package { "jenkins":
    name => "jenkins",
    ensure => present,
    configfiles => keep,
    require  => Exec['apt-get update', 'jenkins defaults']
}