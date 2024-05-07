ARG FEDORA_MAJOR_VERSION=40

FROM ghcr.io/ny5re/bluevanilla:${FEDORA_MAJOR_VERSION}

COPY rootfs/ /

RUN rpm-ostree override remove toolbox --install distrobox && \
    rpm-ostree install \
    https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
    https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm && \
    rpm-ostree install rpmfusion-free-release rpmfusion-nonfree-release \
    --uninstall rpmfusion-free-release \
    --uninstall rpmfusion-nonfree-release && \
    rpm-ostree install steam-devices && \
    rpm-ostree install intel-media-driver libva-intel-driver && \
    rpm-ostree override remove libavfilter-free libavformat-free libavcodec-free libavutil-free libpostproc-free libswresample-free libswscale-free --install=ffmpeg && \
    rpm-ostree install gstreamer1-plugin-libav gstreamer1-plugins-bad-free-extras gstreamer1-plugins-ugly gstreamer1-vaapi && \
####      QEMU     ####
    rpm-ostree install virt-install libvirt-daemon-config-network libvirt-daemon-kvm qemu-kvm virt-manager virt-viewer guestfs-tools && \
    rpm-ostree install libguestfs-tools python3-libguestfs virt-top libvirt-devel bridge-utils edk2-ovmf && \
####      QEMU     ####
####     ny5RE     ####
    rpm-ostree install ffmpeg-libs ffmpegthumbnailer libva-utils openrgb-udev-rules && \
    rpm-ostree override remove firefox firefox-langpacks gnome-tour yelp gnome-color-manager && \
    systemctl enable swtpm-workaround.service && \
####   ny5RE end   ####
    rpm-ostree override remove mesa-va-drivers --install=mesa-va-drivers-freeworld && \
    rpm-ostree install mesa-vdpau-drivers-freeworld ; \
    rpm-ostree cleanup -m && \
    ostree container commit
