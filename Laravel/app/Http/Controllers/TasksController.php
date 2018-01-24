<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Task;
use App\Tag;
use Carbon\Carbon;

class TasksController extends Controller
{
    public function showMessage(Request $request) {
		$tag = new Tag;
        $tag->tag = $request->tag;
        $tag->datetime = Carbon::now();
        $tag->save();
		return $tag;
    }

    public function getLast(Request $request) {
		$tag = Tag::orderBy('datetime','desc')
					->first();

		return $tag;
    }
}
