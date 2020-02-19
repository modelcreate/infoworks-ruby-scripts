module ModelBuilder
  module SetControls

    def self.run(open_net, open_control)
      closed_valves = open_net.row_objects('wn_valve').select {|v| v.user_text_1 == "CLOSED"}
      prvs = open_net.row_objects('wn_valve').select {|v| v.user_text_5 == "PRESSURE REDUCING"}
      live_meters = open_net.row_objects('wn_meter').select {|v| v.billing_id.nil? == false}
      fixed_heads = open_net.row_objects('wn_fixed_head')

      open_control.transaction_begin

      closed_valves.each {|cv| create_closed_valve(cv, open_control) }
      prvs.each {|cv| create_prv(cv, open_control) }
      live_meters.each {|m| create_meter(m, open_control) }
      fixed_heads.each {|fh| create_fixed_head(fh, open_control) }

      open_control.transaction_commit

    end

    private

    def self.set_ids(valve, ctrl_row)
      ctrl_row.us_node_id = valve.us_node_id
      ctrl_row.ds_node_id = valve.ds_node_id
      ctrl_row.link_suffix = valve.link_suffix
      ctrl_row.asset_id = valve.asset_id
    end


    def self.create_closed_valve(valve, open_ctrl)
      ctrl_row = open_ctrl.new_row_object("wn_ctl_valve")

      set_ids(valve, ctrl_row)
  
      ctrl_row.pipe_closed = true
      ctrl_row.mode = "THV"
      ctrl_row.opening = 0
  
      ctrl_row.write

    end

    def self.create_prv(valve, open_ctrl)
      ctrl_row = open_ctrl.new_row_object("wn_ctl_valve")

      set_ids(valve, ctrl_row)
  
      ctrl_row.mode = "PRV"
      ctrl_row.control_node = valve.ds_node_id
      ctrl_row.pressure = 999
  
      ctrl_row.write

    end

    def self.create_meter(meter, open_ctrl)
      ctrl_row = open_ctrl.new_row_object("wn_ctl_meter")

      set_ids(meter, ctrl_row)

      ctrl_row.live_data_point_id = meter.billing_id
      ctrl_row.write

    end

    def self.create_fixed_head(fh, open_ctrl)
      ctrl_row = open_ctrl.new_row_object("wn_ctl_fixed_head")

      ctrl_row.node_id = fh.node_id
      ctrl_row.fixed_level = fh.user_number_1
      ctrl_row.write

    end

    

  end
end