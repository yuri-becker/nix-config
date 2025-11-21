{ pkgs, ... }:
{
  home.packages = with pkgs; [
    ansible
    ansible-lint
  ];

  programs.zed-editor = {
    extensions = [ "ansible" ];
    userSettings.file_types.Ansible = [
      "**.ansible.yml"
      "**.ansible.yaml"
      "**/defaults/*.yml"
      "**/defaults/*.yaml"
      "**/meta/*.yml"
      "**/meta/*.yaml"
      "**/tasks/*.yml"
      "**/tasks/*.yaml"
      "**/handlers/*.yml"
      "**/handlers/*.yaml"
      "**/group_vars/*.yml"
      "**/group_vars/*.yaml"
      "**/playbooks/*.yaml"
      "**/playbooks/*.yml"
      "**playbook*.yaml"
      "**playbook*.yml"
    ];
  };
}
