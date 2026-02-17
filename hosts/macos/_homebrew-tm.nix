{ ... }:
{
  homebrew = {
    taps = [
      {
        name = "tm/homebrew";
        clone_target = "https://REDACTED_URL/core-platform/homebrew-tm.git";
      }
    ];

    casks = [
      "tm/homebrew/tech-pass"
    ];
  };
}
