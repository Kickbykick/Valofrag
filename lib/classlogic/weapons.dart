class Weapons {

  final String weaponName;
  final int price;
  final String imageName;
  final String weaponClass;
  final String fireRate;
  final String wallPenetration;
  final String magazine;
  final String weaponType;
  final DamageDetails noArmor;
  final DamageDetails lightArmor;
  final DamageDetails heavyArmor;
  
  Weapons({ this.weaponName, this.weaponClass, this.price,
      this.fireRate, this.wallPenetration, this.magazine, this.weaponType,
      this.imageName, this.noArmor, this.lightArmor, this.heavyArmor });

}

class DamageDetails{
  final String damageDistance;
  final int headDamage;
  final int bodyDamage;
  final int legDamage;

  DamageDetails({ this.damageDistance, this.headDamage, this.bodyDamage, this.legDamage });
}