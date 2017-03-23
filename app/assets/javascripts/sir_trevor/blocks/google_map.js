SirTrevor.Blocks.GoogleMap = (function(){

  return SirTrevor.Block.extend({
    type: 'google_map',
    previewable: false,
    formable: true,

    title: function() { return i18n.t('blocks:google_map:title'); },
    description: function() { return i18n.t('blocks:google_map:description'); },

    icon_name: "google_map",

    editorHTML: function() {
      return _.template(this.template, this)(this);
    },

    template: [
      '<div class="clearfix">',
        '<div class="widget-header">',
          '<%= description() %>',
        '</div>',
        '<label>Comma seperated tags</label>',
        '<input type="text" name="search" placeholder="Leave blank to display all items in the exhibit"></input><br>',
        '<input name="cluster_markers" id="cluster_markers" type="hidden" value="false" />',
        '<input name="cluster_markers" id="cluster_markers" type="checkbox" value="true" checked> Cluster overlapping markers. (Markers on the exact same spot are always combined) </input>',
      '</div>'
    ].join("\n"),
  });
})();
