# Docker for Drupal / PHP projects


# How to install this project

1. Clone the repository locally `/var/local/example.com`
1. Copy `example.start.sh` to `start.sh` and **customize** appropriately (see below)
1. Use `start.sh` and `stop.sh` to restart the stack

# How to use this repository

## Scenarion 1: One multirole server

In the most simple scenario, you have a single server which runs all components (Varnish, Database, Apache Solr and your app server).

TODO

## Scenarion 2: Individual components (DB, Apache Solr, Varnish etc.)

Only the one of corresponding container is used in scenario

TODO


## REDIS configuration

```php
// https://gist.github.com/keopx/7d5fe4d7a890c792c43bb79cf56718e0
if (extension_loaded('redis')) {
  $settings['redis.connection']['interface'] = 'PhpRedis';
  $settings['redis.connection']['host'] = 'redis';
  $settings['redis.connection']['port'] = 6379;
  $settings['redis.connection']['persistent'] = TRUE;
  $settings['cache_prefix'] = 'TODO_';

  $settings['container_yamls'][] = 'modules/contrib/redis/example.services.yml';
  $settings['container_yamls'][] = 'modules/contrib/redis/redis.services.yml';

  // Manually add the classloader path, this is required for the container cache bin definition below
  // and allows to use it without the redis module being enabled.
  $class_loader->addPsr4('Drupal\\redis\\', 'modules/contrib/redis/src');

  // Use redis for container cache.
  // The container cache is used to load the container definition itself, and
  // thus any configuration stored in the container itself is not available
  // yet. These lines force the container cache to use Redis rather than the
  // default SQL cache.
  $settings['bootstrap_container_definition'] = [
    'parameters' => [],
    'services' => [
      'redis.factory' => [
        'class' => 'Drupal\redis\ClientFactory',
      ],
      'cache.backend.redis' => [
        'class' => 'Drupal\redis\Cache\CacheBackendFactory',
        'arguments' => ['@redis.factory', '@cache_tags_provider.container', '@serialization.phpserialize'],
      ],
      'cache.container' => [
        'class' => '\Drupal\redis\Cache\PhpRedis',
        'factory' => ['@cache.backend.redis', 'get'],
        'arguments' => ['container'],
      ],
      'cache_tags_provider.container' => [
        'class' => 'Drupal\redis\Cache\RedisCacheTagsChecksum',
        'arguments' => ['@redis.factory'],
      ],
      'serialization.phpserialize' => [
        'class' => 'Drupal\Component\Serialization\PhpSerialize',
      ],
    ],
  ];

  /** @see: https://pantheon.io/docs/redis/ */
  // Always set the fast backend for bootstrap, discover and config, otherwise
  // this gets lost when redis is enabled.
  $settings['cache']['bins']['bootstrap'] = 'cache.backend.chainedfast';
  $settings['cache']['bins']['discovery'] = 'cache.backend.chainedfast';
  $settings['cache']['bins']['config'] = 'cache.backend.chainedfast';

  /** @see: https://github.com/md-systems/redis */
  // Use for all bins otherwise specified.
  $settings['cache']['default'] = 'cache.backend.redis';
}
```