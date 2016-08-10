##
# Simplified catalog controller
class CatalogController < ApplicationController
  include Blacklight::Catalog

  configure_blacklight do |config|
          config.show.oembed_field = :oembed_url_ssm
          config.show.partials.insert(1, :oembed)
          config.view.gallery.partials = [:index_header, :index]
          config.view.masonry.partials = [:index]
          config.view.slideshow.partials = [:index]

          config.show.tile_source_field = :content_metadata_image_iiif_info_ssm
          config.show.partials.insert(1, :openseadragon)

    ## Default parameters to send to solr for all search-like requests. See also SolrHelper#solr_search_params
    config.default_solr_params = {
      qt: 'search',
      rows: 10,
      fl: '*'
    }

    config.document_solr_path = 'get'
    config.document_unique_id_param = 'ids'

    # solr field configuration for search results/index views
    config.index.title_field = 'full_title_tesim'
    
    config.add_search_field 'all_fields', label: 'Everything'
    config.add_search_field 'spotlight_upload_description_tesim', label: 'Description'

    config.add_sort_field 'relevance', sort: 'score desc', label: 'Relevance'
    config.add_sort_field 'timestamp', sort: 'timestamp desc', label: 'Date Modified'

    config.add_field_configuration_to_solr_request!
    
    config.add_facet_field 'spotlight_upload_dc.Subjects_ftesim', :label => 'Subject', :limit => 10
    config.add_facet_field 'spotlight_upload_dc.Coverage-Spatial.Location_ftesim', :label => 'Location', :limit => 10
    config.add_facet_field 'spotlight_upload_dc.Subject.People_ftesim', :label => 'People', :limit => 10
    config.add_facet_field 'spotlight_upload_Language_ftesim', :label => 'Language', :limit => 10
    config.add_facet_field 'spotlight_upload_dc.Date-Created.Searchable_ftesim', :label => 'Date', :limit => 10
    config.add_facet_field 'spotlight_upload_dc.Type.Genre_ftesim', :label => 'Genre', :limit => 10
    config.add_facet_field 'spotlight_upload_Format_tesim', :label => 'Format', :limit => 10
  end
end
