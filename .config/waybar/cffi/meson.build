project(
    'qtile-groups', 'c',
    version: '0.1.0',
    license: 'MIT',
)

shared_library('qtile-groups',
    ['main.c'],
    dependencies: [
        dependency('gtk+-3.0', version : ['>=3.22.0']),
        dependency('libcurl', version: ['>=0.8.22'])
    ],
    name_prefix: ''
)
