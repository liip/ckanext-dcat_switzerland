# coding=UTF-8

import ckan.plugins as plugins
from ckan.lib.plugins import DefaultTranslation
import ckan.plugins.toolkit as toolkit
import logging
log = logging.getLogger(__name__)


class DCATCHBasic(plugins.SingletonPlugin, DefaultTranslation):
    plugins.implements(plugins.ITranslation)

    # ITranslation

    def i18n_domain(self):
        return 'ckanext-dcat_switzerland'
