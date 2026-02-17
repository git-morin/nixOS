{ ... }:
{
  homebrew = {
    taps = [
      {
        name = "tm/homebrew";
        clone_target = "https://git.tmaws.io/core-platform/homebrew-tm.git";
      }
    ];

    casks = [
      "tm/homebrew/tech-pass"
    ];
  };
}
