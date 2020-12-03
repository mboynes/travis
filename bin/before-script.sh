#!/bin/bash

set -e

# Set up paths.
export PATH="${HOME}/.config/composer/vendor/bin:${PATH}"
export OG_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/../" >/dev/null 2>&1 && pwd )"
export THEMES_DIR="${OG_DIR}/themes/"
export PLUGINS_DIR="${OG_DIR}/plugins/"

cd "${OG_DIR}"

# Turn off Xdebug. See https://core.trac.wordpress.org/changeset/40138.
phpenv config-rm xdebug.ini || echo "Xdebug not available"

# Install PHPUnit.
composer global require "phpunit/phpunit=6.1.*"

# Set up the WordPress installation.
export WP_CORE_DIR=/tmp/wordpress/
bash bin/install-wp-tests.sh wordpress_test root '' localhost "${WP_VERSION}"
echo "define( 'JETPACK_DEV_DEBUG', true );" >> "${WP_CORE_DIR}/wp-tests-config.php"

# install memcached.
printf "\n" | pecl install --force memcache 1> /dev/null
curl -s https://raw.githubusercontent.com/Automattic/wp-memcached/master/object-cache.php > "${WP_CORE_DIR}/wp-content/object-cache.php"

# Set up the wp-content directory.
rm -rf "${WP_CORE_DIR}wp-content"
mkdir -p "${WP_CORE_DIR}wp-content"
cp -R . "${WP_CORE_DIR}wp-content/"

# Include VIP Go mu-plugins
cd "${WP_CORE_DIR}wp-content/"
git clone --recursive --depth=1 https://github.com/Automattic/vip-go-mu-plugins-built.git mu-plugins
