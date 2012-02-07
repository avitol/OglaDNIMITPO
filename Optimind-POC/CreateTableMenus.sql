USE [DataPlusPUB]
GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_Menus_menuLevel]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[wtMenus] DROP CONSTRAINT [DF_Menus_menuLevel]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_Menus_menuSeq]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[wtMenus] DROP CONSTRAINT [DF_Menus_menuSeq]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_Menus_menuClass]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[wtMenus] DROP CONSTRAINT [DF_Menus_menuClass]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_wtMenus_menuLink]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[wtMenus] DROP CONSTRAINT [DF_wtMenus_menuLink]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_wtMenus_menuTarget]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[wtMenus] DROP CONSTRAINT [DF_wtMenus_menuTarget]
END

GO

USE [DataPlusPUB]
GO

/****** Object:  Table [dbo].[wtMenus]    Script Date: 02/02/2012 22:51:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[wtMenus]') AND type in (N'U'))
DROP TABLE [dbo].[wtMenus]
GO

USE [DataPlusPUB]
GO

/****** Object:  Table [dbo].[wtMenus]    Script Date: 02/02/2012 22:51:53 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[wtMenus](
	[menuID] [int] NOT NULL,
	[menuName] [varchar](50) NOT NULL,
	[menuLevel] [int] NOT NULL,
	[menuParent] [int] NULL,
	[menuSeq] [int] NOT NULL,
	[menuClass] [varchar](50) NULL,
	[menuLink] [varchar](150) NULL,
	[menuTarget] [varchar](50) NULL,
 CONSTRAINT [PK_wtMenus] PRIMARY KEY CLUSTERED 
(
	[menuID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0 = main menu, 1 = sub-menu, 2= sub-sub-menu etc....' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'wtMenus', @level2type=N'COLUMN',@level2name=N'menuLevel'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'menuID of the parent. IF menuParent=NULL THEN it''s a main menu' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'wtMenus', @level2type=N'COLUMN',@level2name=N'menuParent'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Sequence of the item: from Left to Right IF main menu; from Top to Bottom if sub-menu' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'wtMenus', @level2type=N'COLUMN',@level2name=N'menuSeq'
GO

ALTER TABLE [dbo].[wtMenus] ADD  CONSTRAINT [DF_Menus_menuLevel]  DEFAULT ((0)) FOR [menuLevel]
GO

ALTER TABLE [dbo].[wtMenus] ADD  CONSTRAINT [DF_Menus_menuSeq]  DEFAULT ((0)) FOR [menuSeq]
GO

ALTER TABLE [dbo].[wtMenus] ADD  CONSTRAINT [DF_Menus_menuClass]  DEFAULT ('') FOR [menuClass]
GO

ALTER TABLE [dbo].[wtMenus] ADD  CONSTRAINT [DF_wtMenus_menuLink]  DEFAULT ('#') FOR [menuLink]
GO

ALTER TABLE [dbo].[wtMenus] ADD  CONSTRAINT [DF_wtMenus_menuTarget]  DEFAULT ('_self') FOR [menuTarget]
GO


-->  Table to script = wtmenus ORDER BY menuID
-->  Scripting the full table content
 
 
IF NOT EXISTS (SELECT * FROM wtmenus (NOLOCK) WHERE menuID=1)
  INSERT INTO wtmenus (menuID, menuName, menuLevel, menuParent, menuSeq, menuClass, menuLink, menuTarget)
  VALUES(1, 'Dealer', 0, NULL, 1, NULL, '', NULL)
GO
IF NOT EXISTS (SELECT * FROM wtmenus (NOLOCK) WHERE menuID=2)
  INSERT INTO wtmenus (menuID, menuName, menuLevel, menuParent, menuSeq, menuClass, menuLink, menuTarget)
  VALUES(2, 'View ALL', 1, 1, 3, 'stam1', 'Caroussel.html', 'contentIFRAME')
GO
IF NOT EXISTS (SELECT * FROM wtmenus (NOLOCK) WHERE menuID=3)
  INSERT INTO wtmenus (menuID, menuName, menuLevel, menuParent, menuSeq, menuClass, menuLink, menuTarget)
  VALUES(3, 'Dashboard', 1, 1, 1, NULL, 'dashboardDealer.html', 'contentIFRAME')
GO
IF NOT EXISTS (SELECT * FROM wtmenus (NOLOCK) WHERE menuID=4)
  INSERT INTO wtmenus (menuID, menuName, menuLevel, menuParent, menuSeq, menuClass, menuLink, menuTarget)
  VALUES(4, 'Manufacturer', 0, NULL, 0, 'manuf', 'dashboardManuf.html', 'contentIFRAME')
GO
IF NOT EXISTS (SELECT * FROM wtmenus (NOLOCK) WHERE menuID=5)
  INSERT INTO wtmenus (menuID, menuName, menuLevel, menuParent, menuSeq, menuClass, menuLink, menuTarget)
  VALUES(5, 'View ALL', 1, 4, 3, 'stam2 stam3', 'Caroussel.html', 'contentIFRAME')
GO
IF NOT EXISTS (SELECT * FROM wtmenus (NOLOCK) WHERE menuID=6)
  INSERT INTO wtmenus (menuID, menuName, menuLevel, menuParent, menuSeq, menuClass, menuLink, menuTarget)
  VALUES(6, 'Dashboard', 1, 4, 1, NULL, 'dashboardManuf.html', 'contentIFRAME')
GO
IF NOT EXISTS (SELECT * FROM wtmenus (NOLOCK) WHERE menuID=7)
  INSERT INTO wtmenus (menuID, menuName, menuLevel, menuParent, menuSeq, menuClass, menuLink, menuTarget)
  VALUES(7, 'Mapping', 0, NULL, 2, 'maping', 'Maps.html', 'contentIFRAME')
GO
