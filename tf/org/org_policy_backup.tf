resource "aws_organizations_policy_attachment" "r1" {
  count     = local.workspace["control_tower"] ? 0 : 1
  policy_id = aws_organizations_policy.r1.id
  target_id = data.aws_organizations_organizational_units.org.children[1].id
}

resource "aws_organizations_policy_attachment" "r2" {
  count     = local.workspace["control_tower"] ? 0 : 1
  policy_id = aws_organizations_policy.r2.id
  target_id = data.aws_organizations_organizational_units.org.children[1].id
}

resource "aws_organizations_policy_attachment" "r3" {
  count     = local.workspace["control_tower"] ? 0 : 1
  policy_id = aws_organizations_policy.r3.id
  target_id = data.aws_organizations_organizational_units.org.children[1].id
}

resource "aws_organizations_policy" "r1" {
  name        = var.backup_regions.r1
  description = format("%s Backup Policy", var.backup_regions.r1)
  type        = "BACKUP_POLICY"
  tags        = var.tags
  content     = <<CONTENT
{
  "plans": {
    "${var.backup_regions.r1}Plans": {
      "regions": {
        "@@assign": [
          "${var.backup_regions.r1e}"
        ]
      },
      "rules": {
        "daily_backup": {
          "schedule_expression": {
            "@@assign": "${var.backup_crons.r1daily}"
          },
          "start_backup_window_minutes": {
            "@@assign": "60"
          },
          "complete_backup_window_minutes": {
            "@@assign": "180"
          },
          "target_backup_vault_name": {
            "@@assign": "Default"
          },
          "lifecycle": {
            "delete_after_days": {
              "@@assign": "30"
            }
          }
        },
        "weekly_backup": {
          "schedule_expression": {
            "@@assign": "${var.backup_crons.r1weekly}"
          },
          "start_backup_window_minutes": {
            "@@assign": "60"
          },
          "complete_backup_window_minutes": {
            "@@assign": "180"
          },
          "target_backup_vault_name": {
            "@@assign": "Default"
          },
          "lifecycle": {
            "delete_after_days": {
              "@@assign": "42"
            }
          }
        },
        "monthly_backup": {
          "schedule_expression": {
            "@@assign": "${var.backup_crons.r1monthly}"
          },
          "start_backup_window_minutes": {
            "@@assign": "60"
          },
          "complete_backup_window_minutes": {
            "@@assign": "180"
          },
          "target_backup_vault_name": {
            "@@assign": "Default"
          },
          "lifecycle": {
            "delete_after_days": {
              "@@assign": "366"
            }
          }
        },
        "yearly_backup": {
          "schedule_expression": {
            "@@assign": "${var.backup_crons.r1yearly}"
          },
          "start_backup_window_minutes": {
            "@@assign": "60"
          },
          "complete_backup_window_minutes": {
            "@@assign": "180"
          },
          "target_backup_vault_name": {
            "@@assign": "Default"
          },
          "lifecycle": {
            "delete_after_days": {
              "@@assign": "2555"
            }
          }
        }
      },
      "selections": {
        "tags": {
          "backup": {
            "iam_role_arn": {
              "@@assign": "arn:aws:iam::$account:role/AWSBackup"
            },
            "tag_key": {
              "@@assign": "backup"
            },
            "tag_value": {
              "@@assign": [
                "true"
              ]
            }
          }
        }
      },
      "advanced_backup_settings": {
        "ec2": {
          "windows_vss": {
            "@@assign": "enabled"
          }
        }
      }
    }
  }
}
CONTENT
}

resource "aws_organizations_policy" "r2" {
  name        = var.backup_regions.r2
  description = format("%s Backup Policy", var.backup_regions.r2)
  type        = "BACKUP_POLICY"
  tags        = var.tags
  content     = <<CONTENT
{
  "plans": {
    "${var.backup_regions.r2}Plans": {
      "regions": {
        "@@assign": [
          "${var.backup_regions.r2e}"
        ]
      },
      "rules": {
        "daily_backup": {
          "schedule_expression": {
            "@@assign": "${var.backup_crons.r2daily}"
          },
          "start_backup_window_minutes": {
            "@@assign": "60"
          },
          "complete_backup_window_minutes": {
            "@@assign": "180"
          },
          "target_backup_vault_name": {
            "@@assign": "Default"
          },
          "lifecycle": {
            "delete_after_days": {
              "@@assign": "30"
            }
          }
        },
        "weekly_backup": {
          "schedule_expression": {
            "@@assign": "${var.backup_crons.r2weekly}"
          },
          "start_backup_window_minutes": {
            "@@assign": "60"
          },
          "complete_backup_window_minutes": {
            "@@assign": "180"
          },
          "target_backup_vault_name": {
            "@@assign": "Default"
          },
          "lifecycle": {
            "delete_after_days": {
              "@@assign": "42"
            }
          }
        },
        "monthly_backup": {
          "schedule_expression": {
            "@@assign": "${var.backup_crons.r2monthly}"
          },
          "start_backup_window_minutes": {
            "@@assign": "60"
          },
          "complete_backup_window_minutes": {
            "@@assign": "180"
          },
          "target_backup_vault_name": {
            "@@assign": "Default"
          },
          "lifecycle": {
            "delete_after_days": {
              "@@assign": "366"
            }
          }
        },
        "yearly_backup": {
          "schedule_expression": {
            "@@assign": "${var.backup_crons.r2yearly}"
          },
          "start_backup_window_minutes": {
            "@@assign": "60"
          },
          "complete_backup_window_minutes": {
            "@@assign": "180"
          },
          "target_backup_vault_name": {
            "@@assign": "Default"
          },
          "lifecycle": {
            "delete_after_days": {
              "@@assign": "2555"
            }
          }
        }
      },
      "selections": {
        "tags": {
          "backup": {
            "iam_role_arn": {
              "@@assign": "arn:aws:iam::$account:role/AWSBackup"
            },
            "tag_key": {
              "@@assign": "backup"
            },
            "tag_value": {
              "@@assign": [
                "true"
              ]
            }
          }
        }
      },
      "advanced_backup_settings": {
        "ec2": {
          "windows_vss": {
            "@@assign": "enabled"
          }
        }
      }
    }
  }
}
CONTENT
}

resource "aws_organizations_policy" "r3" {
  name        = var.backup_regions.r3
  description = format("%s Backup Policy", var.backup_regions.r3)
  type        = "BACKUP_POLICY"
  tags        = var.tags
  content     = <<CONTENT
{
  "plans": {
    "${var.backup_regions.r3}Plans": {
      "regions": {
        "@@assign": [
          "${var.backup_regions.r3e}"
        ]
      },
      "rules": {
        "daily_backup": {
          "schedule_expression": {
            "@@assign": "${var.backup_crons.r3daily}"
          },
          "start_backup_window_minutes": {
            "@@assign": "60"
          },
          "complete_backup_window_minutes": {
            "@@assign": "180"
          },
          "target_backup_vault_name": {
            "@@assign": "Default"
          },
          "lifecycle": {
            "delete_after_days": {
              "@@assign": "30"
            }
          }
        },
        "weekly_backup": {
          "schedule_expression": {
            "@@assign": "${var.backup_crons.r3weekly}"
          },
          "start_backup_window_minutes": {
            "@@assign": "60"
          },
          "complete_backup_window_minutes": {
            "@@assign": "180"
          },
          "target_backup_vault_name": {
            "@@assign": "Default"
          },
          "lifecycle": {
            "delete_after_days": {
              "@@assign": "42"
            }
          }
        },
        "monthly_backup": {
          "schedule_expression": {
            "@@assign": "${var.backup_crons.r3monthly}"
          },
          "start_backup_window_minutes": {
            "@@assign": "60"
          },
          "complete_backup_window_minutes": {
            "@@assign": "180"
          },
          "target_backup_vault_name": {
            "@@assign": "Default"
          },
          "lifecycle": {
            "delete_after_days": {
              "@@assign": "366"
            }
          }
        },
        "yearly_backup": {
          "schedule_expression": {
            "@@assign": "${var.backup_crons.r3yearly}"
          },
          "start_backup_window_minutes": {
            "@@assign": "60"
          },
          "complete_backup_window_minutes": {
            "@@assign": "180"
          },
          "target_backup_vault_name": {
            "@@assign": "Default"
          },
          "lifecycle": {
            "delete_after_days": {
              "@@assign": "2555"
            }
          }
        }
      },
      "selections": {
        "tags": {
          "backup": {
            "iam_role_arn": {
              "@@assign": "arn:aws:iam::$account:role/AWSBackup"
            },
            "tag_key": {
              "@@assign": "backup"
            },
            "tag_value": {
              "@@assign": [
                "true"
              ]
            }
          }
        }
      },
      "advanced_backup_settings": {
        "ec2": {
          "windows_vss": {
            "@@assign": "enabled"
          }
        }
      }
    }
  }
}
CONTENT
}

resource "aws_backup_global_settings" "cross_account" {
  global_settings = {
    "isCrossAccountBackupEnabled" = "true"
  }
}
