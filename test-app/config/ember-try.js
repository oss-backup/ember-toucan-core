'use strict';

const getChannelURL = require('ember-source-channel-url');
const { embroiderOptimized } = require('@embroider/test-setup');

module.exports = async function () {
  let releaseVersion = await getChannelURL('release');

  return {
    usePnpm: true,
    scenarios: [
      {
        name: 'ember-lts-4.8',
        npm: {
          devDependencies: {
            'ember-source': '~4.8.0',
          },
        },
      },
      {
        name: 'ember-release',
        npm: {
          devDependencies: {
            'ember-source': await getChannelURL('release'),
          },
        },
      },
      {
        name: 'ember-beta',
        npm: {
          devDependencies: {
            'ember-source': await getChannelURL('beta'),
          },
        },
      },
      {
        name: 'ember-canary',
        npm: {
          devDependencies: {
            'ember-source': await getChannelURL('canary'),
          },
        },
      },
      embroiderOptimized({
        name: 'ember-lts-4.8 + embroider-optimized',
        npm: {
          devDependencies: {
            'ember-source': '~4.8.0',
          },
        },
      }),
      embroiderOptimized({
        name: 'ember-release + embroider-optimized',
        npm: {
          devDependencies: {
            'ember-source': releaseVersion,
          },
        },
      }),
    ],
  };
};
