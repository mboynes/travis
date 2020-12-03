<?php

// Use the environment WP_CONTENT_DIR, or, if not TRAVIS, determine it relatively.
$_content_dir = getenv( 'WP_CONTENT_DIR' );
if ( $_content_dir ) {
	define( 'WP_CONTENT_DIR', $_content_dir );
} elseif ( ( ! defined( 'TRAVIS' ) || ! TRAVIS ) ) {
	$cwd = explode( 'wp-content', dirname( __FILE__ ) );
	define( 'WP_CONTENT_DIR', $cwd[0] . '/wp-content' );
}

// Load Core's test suite
$_tests_dir = getenv('WP_TESTS_DIR');
if ( !$_tests_dir ) {
	$_tests_dir = '/tmp/wordpress-tests-lib';
}
require_once $_tests_dir . '/includes/functions.php';

/**
 * Setup our environment (theme, plugins).
 */
function _manually_load_environment() {
	remove_action( 'switch_theme', 'rri_wpcom_action_switch_theme' );

	// Set our theme
	switch_theme( 'travis-test' );

	if ( ! defined( 'JETPACK_DEV_DEBUG' ) ) {
		define( 'JETPACK_DEV_DEBUG', true );
	}

	// Sledgehammer X-hacker header.
	remove_all_actions( 'send_headers' );
}
tests_add_filter( 'muplugins_loaded', __NAMESPACE__ . '\_manually_load_environment' );

// Include core's bootstrap
require $_tests_dir . '/includes/bootstrap.php';
