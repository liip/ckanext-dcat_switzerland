import ckan.plugins as plugins
import ckan.plugins.toolkit as toolkit
from ckanext.showcase.plugin import ShowcasePlugin
import logging

log = logging.getLogger(__name__)


class DcatSwitzerlandPlugin(plugins.SingletonPlugin):
    plugins.implements(plugins.IConfigurer)

    # IConfigurer

    def update_config(self, config_):
        toolkit.add_template_directory(config_, 'templates')
        toolkit.add_public_directory(config_, 'public')
        toolkit.add_resource('fanstatic', 'dcat_switzerland')


class DcatSwitzerlandShowcaseIDatasetFormPlugin(ShowcasePlugin):
    plugins.implements(plugins.IDatasetForm, inherit=True)

    # IDatasetForm

    def _modify_package_schema(self, schema):
        schema.update({
            'twitter': [toolkit.get_validator('ignore_missing'),
                        toolkit.get_converter('convert_to_extras'),
                        ]
        })
        return schema

    def create_package_schema(self):
        schema = super(DcatSwitzerlandShowcaseIDatasetFormPlugin, self).create_package_schema()
        schema = self._modify_package_schema(schema)
        return schema

    def update_package_schema(self):
        schema = super(DcatSwitzerlandShowcaseIDatasetFormPlugin, self).update_package_schema()
        schema = self._modify_package_schema(schema)
        return schema

    def show_package_schema(self):
        schema = super(DcatSwitzerlandShowcaseIDatasetFormPlugin, self).show_package_schema()
        schema.update({
            'twitter': [toolkit.get_converter('convert_from_extras'),
                        toolkit.get_validator('ignore_missing')]
        })
        return schema
