//codename: wamer_days_quest_fireboots.gsc
//purpose: provide a joint tag ref for globals
//release: 2023 as part of tranzit 2.0 v2 update

/*
    //JOINTS JOINTS JOINTS JOINTS JOINTS
    //JOINTS JOINTS JOINTS JOINTS JOINTS JOINTS

j_mainroot
j_coatfront_le
j_coatfront_ri
j_coatrear_le
j_coatrear_ri
j_hip_le
j_hip_ri
j_spinelower
j_hiptwist_le
j_hiptwist_ri
j_knee_le
j_knee_ri
j_shorts_le
j_shorts_lift_le
j_shorts_lift_ri
j_shorts_ri
j_spineupper
j_ankle_le
j_ankle_ri
j_knee_bulge_le
j_knee_bulge_ri
j_spine4
j_ball_le
j_ball_ri
j_clavicle_le
j_clavicle_ri
j_neck
j_shoulderraise_le
j_shoulderraise_ri
j_head
j_shoulder_le
j_shoulder_ri
j_brow_le
j_brow_ri
j_cheek_le
j_cheek_ri
j_elbow_bulge_le
j_elbow_bulge_ri
j_elbow_le
j_elbow_ri
j_eye_lid_bot_le
j_eye_lid_bot_ri
j_eye_lid_top_le
j_eye_lid_top_ri
j_eyeball_le
j_eyeball_ri
j_head_end
j_jaw
j_levator_le
j_levator_ri
j_lip_top_le
j_lip_top_ri
j_mouth_le
j_mouth_ri
j_shouldertwist_le
j_shouldertwist_ri
j_chin_skinroll
j_helmet
j_lip_bot_le
j_lip_bot_ri
j_wrist_le
j_wrist_ri
j_wristtwist_le
j_wristtwist_ri
j_gun
j_index_le_1
j_index_ri_1
j_mid_le_1
j_mid_ri_1
j_pinky_le_1
j_pinky_ri_1
j_ring_le_1
j_ring_ri_1
j_thumb_le_1
j_thumb_ri_1
j_index_le_2
j_index_ri_2
j_mid_le_2
j_mid_ri_2
j_pinky_le_2
j_pinky_ri_2
j_ring_le_2
j_ring_ri_2
j_thumb_le_2
j_thumb_ri_2
j_index_le_3
j_index_ri_3
j_mid_le_3
j_mid_ri_3
j_pinky_le_3
j_pinky_ri_3
j_ring_le_3
j_ring_ri_3
j_thumb_le_3
j_thumb_ri_3


    //TAGS TAGS TAGS TAGS TAGS TAGS
    //TAGS TAGS TAGS TAGS TAGS TAGS TAGS

//PLAYER TAGS PLAYER TAGS
tag_weapon_left
tag_weapon_right
tag_eye
tag_inhand
torso_stabilizer
tag_stowed_back
tag_origin´
tag_body

//? are these working ?//
tag_flash | fire-like fx at the end of your guns barrel
tag_brass | where bullet casings fly out 





tag_origin // start point of the bone skeleton, fits in radiant origin coordinates
tag_body // origin is linked to body and body is the central point most bones are connected with
tag_drivewheel_l
tag_drivewheel_r 
tag_guidewheel_l_01 // lots of guidewheels ... not sure where to use, maybe individual tank wheel tags - different from UO concept
tag_guidewheel_l_02 
tag_guidewheel_l_03 
tag_guidewheel_l_04 
tag_guidewheel_r_01 
tag_guidewheel_r_02 
tag_guidewheel_r_03 
tag_guidewheel_r_04 
tag_sprocketwheel_l // used for tank sprocketwhees, tag not present in UO
tag_sprocketwheel_r // used for tank sprocketwheels, tag not present in UO
tag_treads_left // used for tank treads
tag_treads_right // used for tank treads
tag_walker0 
tag_walker1 

body_roll_jnt // not sure if this is a tag at all
attach_point_body // not sure about this one

tag_armor1 // armor tags weren't present in UO, guess they are used to attach side armors to. The ddef file structure suggests that armor xmodels are attributed to these tags thru ddef files. There should be more armor tags for the tank turret
It is confusing that you have 8 armor tags but 6 tread armor xmodels per side (= 12 armor pieces on the whole) of Panzer IV
tag_armor2 
tag_armor3 
tag_armor4 
tag_armor5 
tag_armor6 
tag_armor7 
tag_armor8 
tag_detach // exit point for player outside the tank

tag_engine_left // pretty sure those engine tags are NOT used for tanks. In UO they were used for plane rotor engines
tag_engine_right 

tag_enter_back // following tags suggest a better concept for player positions compared to UO
tag_enter_driver 
tag_enter_gunner1 
tag_enter_gunner2 // ??? different entry points outside the vehicle or ..... ????
tag_enter_left 
tag_enter_passenger 
tag_enter_right 
tag_gunner_turret2 
tag_out 
tag_passenger 
tag_passenger2 
tag_passenger3 
tag_playerride 
tag_turret // attach tag for tank turret
tag_gunner_barrel2 
turret_recoil 

attach_point_turret 
mountedgun_base 

tag_barrel 
tag_driver // attach point for driving player

tag_gunner_turret1 // attach point for turret gunner
tag_player 

barrel_recoil // not sure if these are tags or anim references
hatch_open_left 
hatch_open_right 

tag_gunner1 // attach points for (MG?) gunners
tag_flash_gunner1 // guess: muzzle flash fx attach point 
tag_gunner2 
tag_flash_gunner2 

turret_animate1 // this definitely is an anim reference

tag_flash // should be main cannon flash fx attach point
tag_gunner_barrel1 

barrel_animate1 

tag_gunner_brass1 
tag_gunner_hands1 // attach point for player models hand tags
*/