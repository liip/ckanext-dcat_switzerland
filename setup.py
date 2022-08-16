from setuptools import setup, find_packages

version = '0.0.1'

setup(
    name='ckanext-dcat_switzerland',
    version=version,
    description="Plugin for setting up Swiss datacatalogs compatible with DCAT-AP CH",
    long_description='''\
    ''',
    classifiers=[],
    keywords='ckan dcat ch',
    author='Liip AG',
    author_email='ogdch@liip.ch',
    url='https://github.com/liip/ckanext-dcat_switzerland',
    license='AGPL',
    packages=find_packages(exclude=['ez_setup', 'examples', 'tests']),
    namespace_packages=['ckanext'],
    include_package_data=True,
    zip_safe=False,
    install_requires=[
        # -*- Extra requirements: -*-
    ],
    entry_points='''
    [ckan.plugins]
    dcat_ch_base=ckanext.dcat_switzerland:DCATCHBasic
    
    [babel.extractors]
    ckan = ckan.lib.extract:extract_ckan
    ''',
    message_extractors={
        'ckanext': [
            ('**.py', 'python', None),
            ('**.js', 'javascript', None),
            ('**/templates/**.html', 'ckan', None),
        ],
    },
)
