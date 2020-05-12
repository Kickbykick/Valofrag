class Character {

  final String characterName;
  final String role;
  final String agentDetail;
  final String firstAbility;
  final String secondAbility;
  final String signatureAbility;
  final String ultimateAbility;
  final String firstAbilityLink;
  final String secondAbilityLink;
  final String signatureAbilityLink;
  final String ultimateAbilityLink;
  final int firstAbilityCost;
  final int secondAbilityCost;
  final int signatureAbilityCost;
  final int ultimateAbilityCost;
  final int firstAbilityCharge;
  final int secondAbilityCharge;
  final int signatureAbilityCharge;
  final int ultimateAbilityCharge;
  
  Character({ this.characterName, this.role, this.agentDetail, this.firstAbility, this.secondAbility, this.signatureAbility, this.ultimateAbility,
  this.firstAbilityLink, this.secondAbilityLink, this.signatureAbilityLink, this.ultimateAbilityLink,
  this.firstAbilityCost, this.secondAbilityCost, this.signatureAbilityCost, this.ultimateAbilityCost,
  this.firstAbilityCharge, this.secondAbilityCharge, this.signatureAbilityCharge, this.ultimateAbilityCharge });

  @override
  String toString() {
    return super.toString();
  }
}