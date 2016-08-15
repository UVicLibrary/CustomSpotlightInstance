class GoogleMapBlock < SirTrevorRails::Block

  #get items from solr to display on the map block
  #search value is from block
  def getsolr
    items = Array.new
    solr = RSolr.connect :url => 'http://localhost:8983/solr/blacklight-core'
    res = solr.get 'select', :params => {
      :q=>self.search.gsub(',',' OR '),
      :start=>0,
      :rows=>1000,
      :fl=> ['id', 'exhibit_test-2_public_bsi', 'thumbnail_url_ssm', 'full_title_tesim', 'spotlight_upload_dc.Coverage-Spatial.Location_tesim', 'spotlight_upload_dc.Coverage-Spatial.Location_ftesim', 'spotlight_upload_dc.description_tesim'],
      :fq=> 'spotlight_upload_dc.Coverage-Spatial.Location_tesim:[* TO *]',
      :wt=> 'ruby'
    }

    #only return items that have a valid lat/long in its location field
    res['response']['docs'].each do |r|
      if r['spotlight_upload_dc.Coverage-Spatial.Location_tesim'][0].match(/(-?\d{1,3}\.\d+)/) != nil
        items.push(r)
      end
    end
    #sort items by title
    items.sort!{|a,b| a['full_title_tesim'][0].downcase <=> b['full_title_tesim'][0].downcase}
  end


end
