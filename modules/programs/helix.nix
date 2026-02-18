{ ... }: {
  programs.helix = {
    enable = true;
    settings = {
      theme = "nord";
      editor.cursor-shape = {
        insert = "bar";
        normal = "block";
        select = "underline";
      };
      editor.file-picker = {
        hidden = false;
      };
    };
  };
}
