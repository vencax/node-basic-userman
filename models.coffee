
module.exports = (sequelize, DataTypes) ->

  User = sequelize.define "user",
    username:
      type: DataTypes.STRING
      allowNull: false
      unique: true
    name:
      type: DataTypes.STRING
      allowNull: false
    email:
      type: DataTypes.STRING
    gid:
      type: DataTypes.INTEGER
      allowNull: false
    password:
      type: DataTypes.STRING
      allowNull: false
    status:
      type: DataTypes.ENUM('enabled', 'disabled')
      defaultValue: 'enabled'
  ,
    tableName: "users"


  Group = sequelize.define "group",
    name:
      type: DataTypes.STRING
      allowNull: false
      unique: true
    status: DataTypes.STRING
  ,
    tableName: "groups"


  MShip = sequelize.define "usergroup_mship",
    user_id:
      type: DataTypes.INTEGER
      primaryKey: true
    group_id:
      type: DataTypes.INTEGER
      primaryKey: true
  ,
    timestamps: false


  User.belongsToMany Group, {through: 'usergroup_mship', foreignKey: 'user_id'}
  Group.belongsToMany User, {through: 'usergroup_mship', foreignKey: 'group_id'}
  Group.hasOne User, {foreignKey: 'gid'}
