# Most tweaks taken from upstream "hardened" profile
# https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/profiles/hardened.nix
{
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkOverride;
in {
  security = {
    # Breaks WiFi on laptop
    # lockKernelModules = true;
    protectKernelImage = lib.mkDefault true;
    forcePageTableIsolation = true;

    # apparmor.enable = true;
    # apparmor.killUnconfinedConfinables = true;

    chromiumSuidSandbox.enable = true;
  };

  boot = {
    kernelPackages = lib.mkDefault pkgs.linuxPackages_cachyos-hardened;

    tmp = {
      useTmpfs = true;
      cleanOnBoot = true;
    };

    kernelParams = [
      # Slab/slub zeroing, don't merge,
      "init_on_alloc=1"
      "init_on_free=1"
      "slab_nomerge"

      # Overwrite free'd pages
      "page_poison=1"

      # Enable page allocator randomization
      "page_alloc.shuffle=1"

      # Disable vsyscalls. May break old binaries.
      "vsyscall=none"

      # Disable debugfs
      "debugfs=off"
    ];

    blacklistedKernelModules = [
      # Obscure network protocols
      "ax25"
      "netrom"
      "rose"

      # Old or rare or insufficiently audited filesystems
      "adfs"
      "affs"
      "bfs"
      "befs"
      "cramfs"
      "efs"
      "erofs"
      "exofs"
      "freevxfs"
      "f2fs"
      "hfs"
      "hpfs"
      "jfs"
      "minix"
      "nilfs2"
      "ntfs"
      "omfs"
      "qnx4"
      "qnx6"
      "sysv"
      "ufs"
    ];

    kernel.sysctl = {
      # Restrict ptrace() usage to processes with a pre-defined relationship
      # (e.g., parent/child)
      "kernel.yama.ptrace_scope" = mkOverride 500 1;

      # Hide kptrs even for processes with CAP_SYSLOG
      "kernel.kptr_restrict" = mkOverride 500 2;

      # Disable bpf() JIT (to eliminate spray attacks)
      "net.core.bpf_jit_enable" = false;

      # Disable ftrace debugging
      "kernel.ftrace_enabled" = false;

      # Enable strict reverse path filtering (that is, do not attempt to route
      # packets that "obviously" do not belong to the iface's network; dropped
      # packets are logged as martians).
      "net.ipv4.conf.all.log_martians" = true;
      "net.ipv4.conf.all.rp_filter" = "1";
      "net.ipv4.conf.default.log_martians" = true;
      "net.ipv4.conf.default.rp_filter" = "1";

      # Ignore broadcast ICMP (mitigate SMURF)
      "net.ipv4.icmp_echo_ignore_broadcasts" = true;

      # Ignore incoming ICMP redirects (note: default is needed to ensure that the
      # setting is applied to interfaces added after the sysctls are set)
      "net.ipv4.conf.all.accept_redirects" = false;
      "net.ipv4.conf.all.secure_redirects" = false;
      "net.ipv4.conf.default.accept_redirects" = false;
      "net.ipv4.conf.default.secure_redirects" = false;
      "net.ipv6.conf.all.accept_redirects" = false;
      "net.ipv6.conf.default.accept_redirects" = false;

      # Ignore outgoing ICMP redirects (this is ipv4 only)
      "net.ipv4.conf.all.send_redirects" = false;
      "net.ipv4.conf.default.send_redirects" = false;

      # Fix for Chromium/Electron sandboxing with hardened kernel
      "kernel.unprivileged_userns_clone" = 1;
    };
  };
}
