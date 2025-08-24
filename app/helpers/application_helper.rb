module ApplicationHelper
  def sidebar_item_classes(current = false)
    classes = [
      "flex w-full items-center gap-3 rounded-lg px-2 py-2.5 text-left text-base/6 font-medium text-zinc-950 sm:py-2 sm:text-sm/5",
      "*:data-[slot=icon]:size-6 *:data-[slot=icon]:shrink-0 *:data-[slot=icon]:fill-zinc-500 sm:*:data-[slot=icon]:size-5",
      "hover:bg-zinc-950/5 hover:*:data-[slot=icon]:fill-zinc-950",
      "dark:text-white dark:*:data-[slot=icon]:fill-zinc-400",
      "dark:hover:bg-white/5 dark:hover:*:data-[slot=icon]:fill-white"
    ]

    if current
      classes << "bg-zinc-950/5 *:data-[slot=icon]:fill-zinc-950 dark:bg-white/5 dark:*:data-[slot=icon]:fill-white"
    end

    classes.join(" ")
  end
end
