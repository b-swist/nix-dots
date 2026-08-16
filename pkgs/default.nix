{ final, ... }:
{
  doasedit = final.callPackage ./doasedit { };
  runny = final.callPackage ./runny { };
}
