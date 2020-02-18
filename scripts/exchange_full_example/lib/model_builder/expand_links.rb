
module ModelBuilder
  module ExpandLinks

    def self.run (net)

      # Expanding will only work on select objects
      # Clear the existing selection and select all valves in model
      net.clear_selection
      net.row_objects('wn_valve').each do |ro|
        ro.selected = true
      end

      # Before we modify any data we must open a transaction
      net.transaction_begin

      # These settings match those found in the UI
      expand_settings = {
        'Expansion threshold' => 2.0,
        'Minimum resultant length' => 1.0,
        'Protect connection points' => false,
        'Recalculate Length' => true,
        'Use user flag' => true,
        'Tables' =>['wn_valve'], # Array of all tables you wish to expand
        'Flag' => '#A'
      }

      # Expands all selected links
      net.expand_short_links(expand_settings)

      # Commit all changes we have made to the network
      net.transaction_commit

      # Remove selection after expansion
      net.clear_selection

    end
  end
end