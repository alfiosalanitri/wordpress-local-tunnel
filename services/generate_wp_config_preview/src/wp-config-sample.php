<?php
/**
 * The base configuration for WordPress
 *
 * The wp-config.php creation script uses this file during the installation.
 * You don't have to use the website, you can copy this file to "wp-config.php"
 * and fill in the values.
 *
 * This file contains the following configurations:
 *
 * * Database settings
 * * Secret keys
 * * Database table prefix
 * * ABSPATH
 *
 * @link https://developer.wordpress.org/advanced-administration/wordpress/wp-config/
 *
 * @package WordPress
 */

// ** Database settings - You can get this info from your web host ** //
/** The name of the database for WordPress */
define( 'DB_NAME', 'database_name_here' );

/** Database username */
define( 'DB_USER', 'username_here' );

/** Database password */
define( 'DB_PASSWORD', 'password_here' );

/** Database hostname */
define( 'DB_HOST', 'localhost' );

/** Database charset to use in creating database tables. */
define( 'DB_CHARSET', 'utf8' );

/** The database collate type. Don't change this if in doubt. */
define( 'DB_COLLATE', '' );

/**#@+
 * Authentication unique keys and salts.
 *
 * Change these to different unique phrases! You can generate these using
 * the {@link https://api.wordpress.org/secret-key/1.1/salt/ WordPress.org secret-key service}.
 *
 * You can change these at any point in time to invalidate all existing cookies.
 * This will force all users to have to log in again.
 *
 * @since 2.6.0
 */
define('AUTH_KEY',         ',SM.DWR7QGL|.|1-dp&<`:}N(@K=rAAzN`F|eIFU/z_M+3/HDIGFj3@4|?!9o=61');
define('SECURE_AUTH_KEY',  'G8P5*Sqi6kE^T*T%nXx-~B*+;671!GWqtLX{D8D}Rl 5T}7uz#H$m`.4UIpp qzD');
define('LOGGED_IN_KEY',    'rAxMVQ+10oo$U(hR|t8R2n)&(xy{%,Vbln(7g*FfW<B/j%3jT3g+^;MPK%R8858 ');
define('NONCE_KEY',        '#ZCi4O-8-)x4c+PODB#^!-=`Py~Sep%&xWs@@sT-:OZmMW-@4EseW[K^j(}$DrXG');
define('AUTH_SALT',        'SQ4XpZ}tr{Dw[~@kP,la/+(~m85nyrNvv^+~G.Zz+G/sY|9iR)[gS4e2?QNqs4i/');
define('SECURE_AUTH_SALT', 't64/De=F_l=NQMuQOmeN8wj7:l[l*zJ n=6;hH-)%Abx>_[U$$df-]-[)tXQK[QU');
define('LOGGED_IN_SALT',   '*%qLPpxiB</xj:,.1EGP&G%s[_7sHT$I`x(<,if5bers{:(@O2xqIpq@j~g.3iz{');
define('NONCE_SALT',       'X7mX({r2J?+WA5}6TK +bd+cb[A8{4z_]5cHMvt_!X?q/wOBum!t]B+w4jqt)`t;');

/**#@-*/

/**
 * WordPress database table prefix.
 *
 * You can have multiple installations in one database if you give each
 * a unique prefix. Only numbers, letters, and underscores please!
 *
 * At the installation time, database tables are created with the specified prefix.
 * Changing this value after WordPress is installed will make your site think
 * it has not been installed.
 *
 * @link https://developer.wordpress.org/advanced-administration/wordpress/wp-config/#table-prefix
 */
$table_prefix = 'wp_';

/**
 * For developers: WordPress debugging mode.
 *
 * Change this to true to enable the display of notices during development.
 * It is strongly recommended that plugin and theme developers use WP_DEBUG
 * in their development environments.
 *
 * For information on other constants that can be used for debugging,
 * visit the documentation.
 *
 * @link https://developer.wordpress.org/advanced-administration/debug/debug-wordpress/
 */
define( 'WP_DEBUG', false );

/* Add any custom values between this line and the "stop editing" line. */



/* That's all, stop editing! Happy publishing. */

/** Absolute path to the WordPress directory. */
if ( ! defined( 'ABSPATH' ) ) {
    define( 'ABSPATH', __DIR__ . '/' );
}

/** Sets up WordPress vars and included files. */
require_once ABSPATH . 'wp-settings.php';
