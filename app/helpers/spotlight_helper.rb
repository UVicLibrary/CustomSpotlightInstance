##
# Global Spotlight helpers
module SpotlightHelper
  include ::BlacklightHelper
  include Spotlight::MainAppHelpers

  def get_all_models
    models = Array.new
    solr = RSolr.connect :url => 'http://localhost:8983/solr/blacklight-core'
    res = solr.get 'select', :params => {
      :q=>'*:*',
      :start=>0,
      :rows=>1000,
      :fl=> ['id','spotlight_upload_Sketchfab-uid_tesim'],
      :fq=> 'spotlight_upload_Sketchfab-uid_tesim: [* TO *]',
      :wt=> 'ruby'
    }
    res['response']['docs']
  end

end
