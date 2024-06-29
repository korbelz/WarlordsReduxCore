class CfgFunctions {
	class MRTM {
		class Init {
			file = "scripts\MRTM";
			class settingsMenu {
				ext = ".fsm";
				postInit = 1;
				headerType = -1;
			};
			class openMenu {};
		};
	};
	
	class KS
	{	
		class normalFunctions
		{
			file = "scripts\VUnflip\functions";
			class unflipVehicle {};
			class unflipVehicleAddAction {};
			class isFlipped {};
		};
	};
	
	class DIS {
		class SAM
		{
			file = "scripts\DIS";
			class Frag {};
			class SAMFired {};
			class RegisterSAM {};
			class IsSam {};
			class SAMmaneuver {};
		};
	};
};