import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_animate/flutter_animate.dart';
import '../theme.dart';

class PermissionsScreen extends StatefulWidget {
  const PermissionsScreen({super.key});

  @override
  State<PermissionsScreen> createState() => _PermissionsScreenState();
}

class _PermissionsScreenState extends State<PermissionsScreen> {
  late Map<Permission, bool> _permissionStatus;

  @override
  void initState() {
    super.initState();
    _initializePermissions();
    _checkPermissions();
  }

  void _initializePermissions() {
    _permissionStatus = {
      if (!kIsWeb) ...<Permission, bool>{
        Permission.location: false,
        Permission.camera: false,
        Permission.notification: false,
        Permission.storage: false,
      } else ...<Permission, bool>{
        Permission.camera: false,
      },
    };
  }

  Future<void> _checkPermissions() async {
    for (var permission in _permissionStatus.keys) {
      try {
        final status = await permission.status;
        if (mounted) {
          setState(() {
            _permissionStatus[permission] = status.isGranted;
          });
        }
      } catch (e) {
        debugPrint('Permission $permission not supported: $e');
      }
    }
  }

  Future<void> _requestPermission(Permission permission) async {
    try {
      final status = await permission.request();
      if (mounted) {
        setState(() {
          _permissionStatus[permission] = status.isGranted;
        });
      }
    } catch (e) {
      debugPrint('Failed to request permission $permission: $e');
    }
  }

  String _getPermissionName(Permission permission) {
    if (permission == Permission.location) return 'Location Access';
    if (permission == Permission.camera) return 'Camera';
    if (permission == Permission.notification) return 'Notifications';
    if (permission == Permission.storage) return 'Storage';
    return 'Unknown';
  }

  String _getPermissionDescription(Permission permission) {
    if (permission == Permission.location) {
      return 'To suggest local tree species and track planting locations';
    }
    if (permission == Permission.camera) {
      return 'To document tree planting and growth progress';
    }
    if (permission == Permission.notification) {
      return 'For watering reminders and challenge updates';
    }
    if (permission == Permission.storage) {
      return 'To save tree photos and documents';
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: AppTheme.backgroundGradient,
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Permissions Needed',
                  style: AppTheme.headlineLarge,
                ).animate().fadeIn().slideY(begin: -0.2, end: 0),
                const SizedBox(height: 16),
                Text(
                  'EcoTrack needs these permissions to provide the best experience',
                  textAlign: TextAlign.center,
                  style: AppTheme.bodyLarge,
                ).animate().fadeIn(delay: 200.ms),
                const SizedBox(height: 40),

                // Permission list
                Expanded(
                  child: ListView(
                    children: _permissionStatus.entries.map((entry) {
                      return _buildPermissionCard(entry.key, entry.value);
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPermissionCard(Permission permission, bool isGranted) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: GlassContainer(
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isGranted
                    ? AppTheme.primaryGreen.withOpacity(0.2)
                    : Colors.orange.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isGranted ? Icons.check_circle : Icons.pending,
                color: isGranted ? AppTheme.primaryGreen : Colors.orange,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _getPermissionName(permission),
                    style: AppTheme.titleLarge.copyWith(fontSize: 18),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _getPermissionDescription(permission),
                    style: AppTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            if (!isGranted)
              ElevatedButton(
                onPressed: () => _requestPermission(permission),
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text('Allow'),
              ),
          ],
        ),
      ),
    ).animate().fadeIn().slideX(begin: 0.2, end: 0);
  }
}
