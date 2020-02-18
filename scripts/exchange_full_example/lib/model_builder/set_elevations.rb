module ModelBuilder
    module SetElevations
  
    #TODO: This isn't dynamic and requires the ground grid and inference to be created
    #      until this feature is added I'll need to add a check to see if the person has
    #      imported both the ground grid and created the inference
      def self.run(db, net)

        moInference = db.model_object_from_type_and_id("Inference",1)
        moGroundGrid = db.model_object_from_type_and_id("Gridded Ground Model",1)
        
        net.infer_network_values(moInference,moGroundGrid)

      end
    end
  end