import '../../products/model/productExhibitorModel.dart';

class ProductDetailModel {
  Product? body;
  bool? status;
  int? code;
  String? message;
  ProductDetailModel({this.status, this.code, this.message,this.body});

  ProductDetailModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    code = json['code'];
    message = json['message'];    body = json['body'] != null ? new Product.fromJson(json['body']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['code'] = this.code;
    data['message'] = this.message;
    if (this.body != null) {
      data['body'] = this.body!.toJson();
    }
    return data;
  }
}

class Product {
  String? favourite;
  String? id;
  String? exhibitorId;
  String? name;
  String? description;
  String? suppliedFrom;
  String? agrifoods;
  String? meatAndPoultry;
  String? halal;
  String? dairy;
  String? drinksHotBeverages;
  String? fineFood;
  String? frozenFoods;
  String? organic;
  String? breadAndBakery;
  String? sweetsSnacks;
  String? foodService;
  String? foodProcessing;
  String? safetyAnalytics;
  String? digitalisation;
  String? environmentEnergy;
  String? sciencePioneering;
  String? packagingMachinery;
  String? packagingRawMaterial;
  String? packagingMaterial;
  String? paperConverting;
  String? convertingCartonCorrugatedAndPrint;
  String? measuringTestingProcessControlAndInstruments;
  String? conveyorBeltsAccumulatingAndRelatedMachines;
  String? environmentalSafetyAndRecycling;
  String? intralogistics;
  String? coldChainServices;
  String? refrigerationHvacSystemsAirConditioningTechnologyParts;
  String? storageAndMaterialHandling;
  String? warehousingAndBuildingMaterial;
  String? transportationAndLogisticsServices;
  String? cargoServicesAndFreightForwarders;
  String? automationSoftwareAidcAndIotSolutions;
  String? solarAndAlternateEnergySolutions;
  String? foodParksAndSpecialEconomicZones;
  String? ammoniaAndChemicalSupplies;
  String? supplyChainConsultants;
  String? otherServices;
  String? adhesivesCoatingsInksVarnishesDecorativeMaterials;
  String? printingCodingMarkingStampingLabellingImprintingMachines;
  List<Categories>? categories;
  List<String>? gallery;
  ProductExhibitorData? exhibitor;

  Product(
      {this.favourite,
        this.id,this.exhibitorId,
        this.name,
        this.description,
        this.suppliedFrom,
        this.agrifoods,
        this.meatAndPoultry,
        this.halal,
        this.dairy,
        this.drinksHotBeverages,
        this.fineFood,
        this.frozenFoods,
        this.organic,
        this.breadAndBakery,
        this.sweetsSnacks,
        this.foodService,
        this.foodProcessing,
        this.safetyAnalytics,
        this.digitalisation,
        this.environmentEnergy,
        this.sciencePioneering,
        this.packagingMachinery,
        this.packagingRawMaterial,
        this.packagingMaterial,
        this.paperConverting,
        this.convertingCartonCorrugatedAndPrint,
        this.measuringTestingProcessControlAndInstruments,
        this.conveyorBeltsAccumulatingAndRelatedMachines,
        this.environmentalSafetyAndRecycling,
        this.intralogistics,
        this.coldChainServices,
        this.refrigerationHvacSystemsAirConditioningTechnologyParts,
        this.storageAndMaterialHandling,
        this.warehousingAndBuildingMaterial,
        this.transportationAndLogisticsServices,
        this.cargoServicesAndFreightForwarders,
        this.automationSoftwareAidcAndIotSolutions,
        this.solarAndAlternateEnergySolutions,
        this.foodParksAndSpecialEconomicZones,
        this.ammoniaAndChemicalSupplies,
        this.supplyChainConsultants,
        this.otherServices,
        this.adhesivesCoatingsInksVarnishesDecorativeMaterials,
        this.printingCodingMarkingStampingLabellingImprintingMachines,
        this.categories,
        this.gallery,
        this.exhibitor});

  Product.fromJson(Map<String, dynamic> json) {
    favourite = json['favourite'];
    id = json['id'];
    exhibitorId=json['exhibitor_id'];
    name = json['name'];
    description = json['description'];
    suppliedFrom = json['supplied_from'];
    agrifoods = json['agrifoods'];
    meatAndPoultry = json['meat_and_poultry'];
    halal = json['halal'];
    dairy = json['dairy'];
    drinksHotBeverages = json['drinks_hot_beverages'];
    fineFood = json['fine_food'];
    frozenFoods = json['frozen_foods'];
    organic = json['organic'];
    breadAndBakery = json['bread_and_bakery'];
    sweetsSnacks = json['sweets_snacks'];
    foodService = json['food_service'];
    foodProcessing = json['food_processing'];
    safetyAnalytics = json['safety_analytics'];
    digitalisation = json['digitalisation'];
    environmentEnergy = json['environment_energy'];
    sciencePioneering = json['science_pioneering'];
    packagingMachinery = json['packaging_machinery'];
    packagingRawMaterial = json['packaging_raw_material'];
    packagingMaterial = json['packaging_material'];
    paperConverting = json['paper_converting'];
    convertingCartonCorrugatedAndPrint =
    json['converting_carton_corrugated_and_print'];
    measuringTestingProcessControlAndInstruments =
    json['measuring_testing_process_control_and_instruments'];
    conveyorBeltsAccumulatingAndRelatedMachines =
    json['conveyor_belts_accumulating_and_related_machines'];
    environmentalSafetyAndRecycling =
    json['environmental_safety_and_recycling'];
    intralogistics = json['intralogistics'];
    coldChainServices = json['cold_chain_services'];
    refrigerationHvacSystemsAirConditioningTechnologyParts =
    json['refrigeration_hvac_systems_air_conditioning_technology_parts'];
    storageAndMaterialHandling = json['storage_and_material_handling'];
    warehousingAndBuildingMaterial = json['warehousing_and_building_material'];
    transportationAndLogisticsServices =
    json['transportation_and_logistics_services'];
    cargoServicesAndFreightForwarders =
    json['cargo_services_and_freight_forwarders'];
    automationSoftwareAidcAndIotSolutions =
    json['automation_software_aidc_and_iot_solutions'];
    solarAndAlternateEnergySolutions =
    json['solar_and_alternate_energy_solutions'];
    foodParksAndSpecialEconomicZones =
    json['food_parks_and_special_economic_zones'];
    ammoniaAndChemicalSupplies = json['ammonia_and_chemical_supplies'];
    supplyChainConsultants = json['supply_chain_consultants'];
    otherServices = json['other_services'];
    adhesivesCoatingsInksVarnishesDecorativeMaterials =
    json['adhesives_coatings_inks_varnishes_decorative_materials'];
    printingCodingMarkingStampingLabellingImprintingMachines =
    json['printing_coding_marking_stamping_labelling_imprinting_machines'];
    if (json['categories'] != null) {
      categories = <Categories>[];
      json['categories'].forEach((v) {
        categories!.add(new Categories.fromJson(v));
      });
    }
    gallery = json['gallery'].cast<String>();
    exhibitor = json['exhibitor.json'] != null
        ? new ProductExhibitorData.fromJson(json['exhibitor.json'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['favourite'] = this.favourite;
    data['id'] = this.id;
    data['exhibitor_id']=this.exhibitorId;
    data['name'] = this.name;
    data['description'] = this.description;
    data['supplied_from'] = this.suppliedFrom;
    data['agrifoods'] = this.agrifoods;
    data['meat_and_poultry'] = this.meatAndPoultry;
    data['halal'] = this.halal;
    data['dairy'] = this.dairy;
    data['drinks_hot_beverages'] = this.drinksHotBeverages;
    data['fine_food'] = this.fineFood;
    data['frozen_foods'] = this.frozenFoods;
    data['organic'] = this.organic;
    data['bread_and_bakery'] = this.breadAndBakery;
    data['sweets_snacks'] = this.sweetsSnacks;
    data['food_service'] = this.foodService;
    data['food_processing'] = this.foodProcessing;
    data['safety_analytics'] = this.safetyAnalytics;
    data['digitalisation'] = this.digitalisation;
    data['environment_energy'] = this.environmentEnergy;
    data['science_pioneering'] = this.sciencePioneering;
    data['packaging_machinery'] = this.packagingMachinery;
    data['packaging_raw_material'] = this.packagingRawMaterial;
    data['packaging_material'] = this.packagingMaterial;
    data['paper_converting'] = this.paperConverting;
    data['converting_carton_corrugated_and_print'] =
        this.convertingCartonCorrugatedAndPrint;
    data['measuring_testing_process_control_and_instruments'] =
        this.measuringTestingProcessControlAndInstruments;
    data['conveyor_belts_accumulating_and_related_machines'] =
        this.conveyorBeltsAccumulatingAndRelatedMachines;
    data['environmental_safety_and_recycling'] =
        this.environmentalSafetyAndRecycling;
    data['intralogistics'] = this.intralogistics;
    data['cold_chain_services'] = this.coldChainServices;
    data['refrigeration_hvac_systems_air_conditioning_technology_parts'] =
        this.refrigerationHvacSystemsAirConditioningTechnologyParts;
    data['storage_and_material_handling'] = this.storageAndMaterialHandling;
    data['warehousing_and_building_material'] =
        this.warehousingAndBuildingMaterial;
    data['transportation_and_logistics_services'] =
        this.transportationAndLogisticsServices;
    data['cargo_services_and_freight_forwarders'] =
        this.cargoServicesAndFreightForwarders;
    data['automation_software_aidc_and_iot_solutions'] =
        this.automationSoftwareAidcAndIotSolutions;
    data['solar_and_alternate_energy_solutions'] =
        this.solarAndAlternateEnergySolutions;
    data['food_parks_and_special_economic_zones'] =
        this.foodParksAndSpecialEconomicZones;
    data['ammonia_and_chemical_supplies'] = this.ammoniaAndChemicalSupplies;
    data['supply_chain_consultants'] = this.supplyChainConsultants;
    data['other_services'] = this.otherServices;
    data['adhesives_coatings_inks_varnishes_decorative_materials'] =
        this.adhesivesCoatingsInksVarnishesDecorativeMaterials;
    data['printing_coding_marking_stamping_labelling_imprinting_machines'] =
        this.printingCodingMarkingStampingLabellingImprintingMachines;
    if (this.categories != null) {
      data['categories'] = this.categories!.map((v) => v.toJson()).toList();
    }
    data['gallery'] = this.gallery;
    if (this.exhibitor != null) {
      data['exhibitor.json'] = this.exhibitor!.toJson();
    }
    return data;
  }
}

class Categories {
  String? label;
  List<String>? params;

  Categories({this.label, this.params});

  Categories.fromJson(Map<String, dynamic> json) {
    label = json['label'];
    params = json['params'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['label'] = this.label;
    data['params'] = this.params;
    return data;
  }
}
